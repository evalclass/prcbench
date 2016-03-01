package auc2;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import auc.AUCCalculator;

public class AUCWrapper {
    public static boolean DEBUG = false;

    private double mAucRoc;
    private double mAucPrc;

    private String mListFile;
    private String mFilePR;
    private String mListROC;
    private String mListSPR;
    private String mCrvFile;

    private boolean mParsed;
    private double[] mX;
    private double[] mY;
    private double[] aucs;
    ArrayList<Float> tempMx;
    ArrayList<Float> tempMY;
    
    public AUCWrapper() {
        mAucRoc = 0;
        mAucPrc = 0;
        
        mParsed = false;
        aucs = new double[2];
        tempMx = new ArrayList<Float>();
        tempMY = new ArrayList<Float>();
    }

    public static void main(String[] args) {
        if (DEBUG) {
            String testfname = System.getProperty("user.dir") + "/data/list.txt";

            AUCWrapper auc = new AUCWrapper();
            double[] aucs = auc.calcCurves(testfname);

            
            System.out.println(Arrays.toString(aucs));
            System.out.println(Arrays.toString(auc.getX()));
            System.out.println(Arrays.toString(auc.getY()));
            auc.delFiles();
        } 
    }

    public double [] calcCurves(String fname) {
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
        ps.close();
        try {
            baos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Curve file is not parsed (only stdout is parsed at this stage)
        mParsed = false;

        // Return AUCs
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
        tempMx.clear();
        tempMY.clear();

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
            tempMx.add(scanr.nextFloat());
            tempMY.add(scanr.nextFloat());
        }
        scanr.close();
        try {
            freadr.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Set curve values
        mX = new double[tempMx.size()];
        mY = new double[tempMY.size()];
        for (int i = 0; i < tempMx.size(); i++) {
            mX[i] = tempMx.get(i).doubleValue();
            mY[i] = tempMY.get(i).doubleValue();
        }

        mParsed = true;
    }

    public double[] getX() {
        if (!mParsed) {
            this.readCurveFile();
        }
        return mX;
    }

    public double[] getY() {
        if (!mParsed) {
            this.readCurveFile();
        }
        return mY;
    }
    
    public void clear() {
        mListFile = null;
        mFilePR = null;
        mListROC = null;
        mListSPR = null;
        mCrvFile = null;

        mX = null;
        mY = null;
    }
    
    public String delFiles() {
        if (mListFile == null) {
            return "not deleted";
        }

        File filePR = new File(mFilePR);
        File fileROC = new File(mListROC);
        File fileSPR = new File(mListSPR);

        boolean deleted = filePR.delete();
        if (deleted) {
            deleted = fileROC.delete();
        }
        if (deleted) {
            deleted = fileSPR.delete();
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

}
