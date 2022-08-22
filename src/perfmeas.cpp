#include <stdlib.h>
#include <Rcpp.h>
using namespace Rcpp;


// prec_recall: Computes precision at all possible recall levels
// INPUT:
//   order: vector storing the order of labels
//   labels: label vector
//   vec_size : number of elements of the above vectors
// OUTPUT:
//   list of precision and recall vectors
//
// [[Rcpp::export]]
Rcpp::List perfmeas_prec_recall(const Rcpp::IntegerVector& order, const Rcpp::IntegerVector& labels, int vec_size){
  // Variables
  Rcpp::List ret_val;
  int TP = 0;
  int TN = 0;
  int FP = 0;
  int FN = 0;
  int np = 0;
  std::vector<double> precision(vec_size);
  std::vector<double> recall(vec_size);

  for (int i = 0; i < vec_size; i++) {
    if (labels[i] == 1) {
      np++;
    }
  }

  TP = np;
  TN = 0;
  FP = vec_size - np;
  FN = 0;

  if((TP + FP) > 0) {
    precision[vec_size-1] = TP / (double)(TP + FP);
  }
  else {
    precision[vec_size-1] = 0;
  }

  if((TP + FN) > 0) {
    recall[vec_size-1] = TP / (double)(TP + FN);
  }
  else {
    recall[vec_size-1] = 0;
  }

  for (int i = vec_size - 2; i >= 0; i--) {
    if(labels[order[i + 1] - 1] == 1){
		  TP--;
		  FN++;
	  }
    else {
		  TN++;
		  FP--;
	  }
    if(TP + FP != 0) {
      precision[i] = TP / (double)(TP + FP);
    }
	  else {
	    precision[i] = 0;
	  }
	  if(TP + FN != 0) {
	    recall[i] = TP / (double)(TP + FN);
	  }
	  else {
	    recall[i] = 0;
	  }
  }

  // Return a list with precision and recall
  ret_val["precision"] = precision;
  ret_val["recall"] = recall;

  return ret_val;
}

// trap_rule: Computes the integral according to the trapezoidal rule
// INPUT:
//   x: its values must be in increasing order
//   y: its values correspond to f(x)
//   vec_size : number of elements of the above vectors
// OUTPUT
//   integral value computed by the function
//
// [[Rcpp::export]]
double perfmeas_trap_rule(const Rcpp::NumericVector& x, const Rcpp::NumericVector& y,  int vec_size){
  double integral_value = 0;

  for (int i = 1; i < vec_size; i++) {
    integral_value += ((x[i] - x[i-1]) * (y[i] + y[i-1]) / 2);
  }

  return integral_value;
}
