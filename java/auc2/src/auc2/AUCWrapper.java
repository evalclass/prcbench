package auc2;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import auc.AUCCalculator;

public class AUCWrapper {
    public static boolean DEBUG = false;
    
    private float mAucRoc;
    private float mAucPrc;
    
    private String mListFile;
    private String mFilePR;
    private String mListROC;
    private String mListSPR;
    private String mCrvFile;
    
    private boolean mParsed;
    private float[] mX;
    private float[] mY;
    
    public AUCWrapper() {
        mAucRoc = 0;
        mAucPrc = 0;
        
        mParsed = false;
    }

    public static void main(String[] args) {
        if (DEBUG) {
            String testfname = System.getProperty("user.dir") + "/data/list.txt";
            
            AUCWrapper auc = new AUCWrapper();
            float[] aucs = auc.calcCurves(testfname);
            System.out.println(Arrays.toString(aucs));

            System.out.println(Arrays.toString(auc.getX()));
            System.out.println(Arrays.toString(auc.getY()));
            
            auc.delFiles();
        } else {
            if (args.length == 1) {
                AUCWrapper auc = new AUCWrapper();
                auc.calcCurves(args[0]);
            } else {
                System.err.println("Usage: java -jar auc2 filename");
            }
        }
    }
    
    public float [] calcCurves(String fname) {
        mListFile = fname;
        mFilePR = fname + ".pr";
        mListROC = fname + ".roc";
        mListSPR = fname + ".spr";
        this.setCurveType("SPR");

        // Original code copied from http://stackoverflow.com/questions/8708342
        // Create a stream to hold the output
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(baos);
        
        // IMPORTANT: Save the old System.out!
        PrintStream old = System.out;
        
        // Tell Java to use your special stream
        System.setOut(ps);
        
        // Call AUCCalculator
        String[] args = new String[2];
        args[0] = fname;
        args[1] = "list";
        AUCCalculator.main(args);
        
        // Put things back
        System.out.flush();
        System.setOut(old);
        
        // Parse result
        String[] lines = baos.toString().split("\n");
        this.parseLines(lines);
        
        // Curve file is not parsed
        mParsed = false;
        
        // Return AUCs
        float[] aucs = new float[2];
        aucs[0] = mAucRoc;
        aucs[1] = mAucPrc;

        return aucs;
    }
    
    public void setCurveType(String crvtype) {
        if (crvtype == "PR") {
            mCrvFile = mFilePR;
        } else if (crvtype == "ROC") {
            mCrvFile = mListSPR;
        } else if (crvtype == "SPR") {
            mCrvFile = mListSPR;
        }
        mParsed = false;
    }
    
    public void readCurveFile()  {
        ArrayList<Float> x = new ArrayList<Float>();
        ArrayList<Float> y = new ArrayList<Float>();
        
        // Prepare file
        FileReader freadr = null;
        try {
            freadr = new FileReader(mCrvFile);
        } catch (FileNotFoundException e) {
            System.err.println(e);
        }
        
        // Read file
        Scanner scanr = new Scanner(freadr);
        while (scanr.hasNextFloat()) {
            x.add(scanr.nextFloat());
            y.add(scanr.nextFloat());
        }
        scanr.close();
        
        // Set curve values
        mX = new float[x.size()];
        mY = new float[y.size()];
        for (int i = 0; i < x.size(); i++) {
            mX[i] = x.get(i);
            mY[i] = y.get(i);
        }
        
        mParsed = true;
    }
    
    public float[] getX() {
        if (!mParsed) {
            this.readCurveFile();
        }
        return mX;
    }
    
    public float[] getY() {
        if (!mParsed) {
            this.readCurveFile();
        }
        return mY;
    }
    
    public String delFiles() {
        if (mListFile == null) {
            return "not deleted";
        }
        
        Path fnamePR = Paths.get(mFilePR);
        Path fnameROC = Paths.get(mListROC);
        Path fnameSPR = Paths.get(mListSPR);
        
        boolean deleted = this.defFile(fnamePR);
        if (deleted) {
            deleted = this.defFile(fnameROC);
        }
        if (deleted) {
            deleted = this.defFile(fnameSPR);
        }
        
        mListFile = null;
        mFilePR = null;
        mListROC = null;
        mListSPR = null;
        
        if (deleted) {
            return "deleted";
        } else {
            return "not deleted";
        }
    }
    
    private void parseLines(String[] lines) {
        Pattern p1 = Pattern.compile("^Area Under the Curve for Precision - Recall.*");
        Pattern p2 = Pattern.compile("^Area Under the Curve for ROC.*");
        
        Matcher m1 = p1.matcher("");
        Matcher m2 = p2.matcher("");
        
        String[] aucflds;
        
        for (int i = 0; i < lines.length; i++) {
            m1.reset(lines[i]);
            m2.reset(lines[i]);
            
            if (m1.matches()) {
                aucflds = lines[i].split(" is ");
                mAucPrc = Float.parseFloat(aucflds[1]);
            } else if (m2.matches()) {
                aucflds = lines[i].split(" is ");
                mAucRoc = Float.parseFloat(aucflds[1]);
            }
        }
    }
    
    private boolean defFile(Path path) {
        //delete if exists
        try {
            Files.deleteIfExists(path);
        } catch (IOException | SecurityException e) {
            return false;
        }
        return true;
    }

}
