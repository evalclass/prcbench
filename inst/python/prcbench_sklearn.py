"""Standalone precision-recall curve calculation derived from scikit-learn.

This module is a self-contained port of the precision-recall curve logic from
scikit-learn's ``sklearn/metrics/_ranking.py``.  It is vendored inside prcbench
so that the scikit-learn algorithm can be benchmarked without depending on the
scikit-learn package itself (which would pull in scipy, joblib and
threadpoolctl).  ``numpy`` is the only requirement.

Provenance
----------
Derived from scikit-learn, file ``sklearn/metrics/_ranking.py`` at commit
``afe5bcd80``:
https://github.com/scikit-learn/scikit-learn/blob/afe5bcd80/sklearn/metrics/_ranking.py

The following functions were derived from that file:

* ``auc``
* ``_binary_uninterpolated_average_precision`` (here ``average_precision_score``)
* ``_sort_inputs_and_compute_classification_thresholds``
* ``confusion_matrix_at_thresholds``
* ``precision_recall_curve``

MODIFIED FROM THE ORIGINAL.  The numerical logic is reproduced unchanged; the
modifications are limited to removing scikit-learn infrastructure that is not
available standalone:

* the array-API dispatch layer (``get_namespace_and_device``, ``xp.*``) is
  replaced by direct ``numpy`` calls;
* ``scipy.integrate.trapezoid`` is replaced by ``numpy.trapezoid``;
* scikit-learn's validation helpers (``check_consistent_length``,
  ``column_or_1d``, ``assert_all_finite``, ``type_of_target``,
  ``_check_pos_label_consistency``, ``_check_sample_weight``) are replaced by
  local equivalents;
* the ``@validate_params`` / ``@_deprecate_positional_args`` decorators are
  dropped;
* multiclass and multilabel support is dropped -- this module is binary only;
* ``prc_curve`` is added as an entry point for the R side.

Original license
----------------
Copyright (c) 2007-2026 The scikit-learn developers.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its contributors
  may be used to endorse or promote products derived from this software
  without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SPDX-License-Identifier: BSD-3-Clause
"""

import warnings

import numpy as np

__all__ = [
    "auc",
    "average_precision_score",
    "confusion_matrix_at_thresholds",
    "precision_recall_curve",
    "prc_curve",
]


#
# Local replacements for the scikit-learn validation helpers
#
def _trapezoid(y, x):
    """``scipy.integrate.trapezoid`` stand-in.

    ``numpy.trapezoid`` was added in NumPy 2.0; older versions spell it
    ``numpy.trapz``.
    """
    trapezoid = getattr(np, "trapezoid", None)
    if trapezoid is None:  # pragma: no cover - NumPy < 2.0
        trapezoid = np.trapz
    return trapezoid(y, x)


def _column_or_1d(y):
    """Ravel a column-vector or 1d array, erroring on anything else."""
    y = np.asarray(y)
    shape = np.shape(y)
    if len(shape) == 1:
        return np.ravel(y)
    if len(shape) == 2 and shape[1] == 1:
        return np.ravel(y)
    raise ValueError(
        "y should be a 1d array, got an array of shape {} instead.".format(shape)
    )


def _assert_all_finite(x, input_name=""):
    """Raise if ``x`` contains NaN or infinity."""
    x = np.asarray(x)
    if x.dtype.kind not in "fc":
        return
    if not np.isfinite(x).all():
        raise ValueError(
            "Input {}contains NaN or infinity.".format(
                "{} ".format(input_name) if input_name else ""
            )
        )


def _check_consistent_length(*arrays):
    """Raise if the inputs do not all have the same length."""
    lengths = [len(np.asarray(a)) for a in arrays if a is not None]
    uniques = np.unique(lengths)
    if len(uniques) > 1:
        raise ValueError(
            "Found input variables with inconsistent numbers of samples: {}".format(
                [int(length) for length in lengths]
            )
        )


def _check_sample_weight(sample_weight, y):
    """Validate ``sample_weight`` against ``y``."""
    sample_weight = np.asarray(sample_weight, dtype=np.float64)
    if sample_weight.ndim != 1:
        raise ValueError("Sample weights must be 1D array or scalar")
    if sample_weight.shape[0] != len(y):
        raise ValueError(
            "sample_weight.shape == {}, expected ({},)".format(
                sample_weight.shape, len(y)
            )
        )
    return sample_weight


def _check_pos_label_consistency(pos_label, y_true):
    """Local stand-in for scikit-learn's ``_check_pos_label_consistency``.

    Binary only: when ``pos_label`` is not given it may be inferred if the
    labels are in ``{-1, 1}``, ``{0, 1}``, ``{-1}``, ``{0}`` or ``{1}``.
    """
    classes = np.unique(y_true)
    if pos_label is None and (
        classes.dtype.kind in "OUS"
        or not (
            np.array_equal(classes, [0, 1])
            or np.array_equal(classes, [-1, 1])
            or np.array_equal(classes, [0])
            or np.array_equal(classes, [-1])
            or np.array_equal(classes, [1])
        )
    ):
        classes_repr = ", ".join(repr(c) for c in classes.tolist())
        raise ValueError(
            "y_true takes value in {{{}}} and pos_label is not specified: either "
            "make y_true take value in {{0, 1}} or {{-1, 1}} or pass pos_label "
            "explicitly.".format(classes_repr)
        )
    if pos_label is None:
        pos_label = 1
    return pos_label


def _check_binary(y_true):
    """Local stand-in for ``type_of_target(y_true) == "binary"``."""
    y_true = np.asarray(y_true)
    if y_true.ndim > 1 and not (y_true.ndim == 2 and y_true.shape[1] == 1):
        raise ValueError("{} format is not supported".format("multilabel-indicator"))
    n_classes = len(np.unique(y_true))
    if n_classes > 2:
        raise ValueError("{} format is not supported".format("multiclass"))


#
# Derived from sklearn.metrics._ranking.auc
#
def auc(x, y):
    """Compute Area Under the Curve (AUC) using the trapezoidal rule."""
    x = _column_or_1d(x)
    y = _column_or_1d(y)
    if x.shape[0] < 2:
        raise ValueError(
            "At least 2 points are needed to compute area under curve, but x.shape "
            "= {}".format(x.shape)
        )

    direction = 1
    dx = np.diff(x)
    if np.any(dx < 0):
        if np.all(dx <= 0):
            direction = -1
        else:
            raise ValueError("x is neither increasing nor decreasing : {}.".format(x))

    area = direction * _trapezoid(y, x)
    return float(area)


#
# Derived from
# sklearn.metrics._ranking._sort_inputs_and_compute_classification_thresholds
#
def _sort_inputs_and_compute_classification_thresholds(
    y_true, y_score, sample_weight=None
):
    """Validate and sort inputs, and compute classification thresholds.

    Performs the following functions:

    * Array validation on `y_true`, `y_score` and `sample_weight`
    * Filters out 0-weighted samples
    * Sorts `y_score`, `y_true` and `sample_weight` according to descending `y_score`
    * Computes thresholds i.e. indices where sorted `y_score` changes
    """
    _check_consistent_length(y_true, y_score, sample_weight)
    y_true = _column_or_1d(y_true)
    y_score = _column_or_1d(y_score)
    _assert_all_finite(y_true)
    _assert_all_finite(y_score)

    # Filter out zero-weighted samples, as they should not impact the result
    if sample_weight is not None:
        sample_weight = _column_or_1d(sample_weight)
        sample_weight = _check_sample_weight(sample_weight, y_true)
        nonzero_weight_mask = sample_weight != 0
        y_true = y_true[nonzero_weight_mask]
        y_score = y_score[nonzero_weight_mask]
        sample_weight = sample_weight[nonzero_weight_mask]

    # sort scores and corresponding truth values
    # NOTE: the original uses ``xp.argsort(y_score, stable=True, descending=True)``.
    # Negating before a stable ascending sort is the NumPy equivalent: it keeps
    # tied scores in their original relative order, which reversing an ascending
    # sort would not.
    desc_score_indices = np.argsort(-y_score, kind="stable")
    y_score = y_score[desc_score_indices]
    y_true = y_true[desc_score_indices]
    if sample_weight is not None:
        sample_weight = sample_weight[desc_score_indices]

    # y_score typically has many tied values. Here we extract
    # the indices associated with the distinct values. We also
    # concatenate a value for the end of the curve.
    distinct_value_indices = np.nonzero(np.diff(y_score))[0]
    threshold_idxs = np.concatenate(
        [distinct_value_indices, np.asarray([y_true.size - 1])]
    )
    return y_true, y_score, sample_weight, threshold_idxs


#
# Derived from sklearn.metrics._ranking.confusion_matrix_at_thresholds
#
def confusion_matrix_at_thresholds(
    y_true, y_score, pos_label=None, sample_weight=None
):
    """Compute tn, fp, fn and tp counts per binary classification threshold.

    Returns ``(tns, fps, fns, tps, thresholds)``.
    """
    # Check to make sure y_true is valid
    _check_binary(y_true)

    pos_label = _check_pos_label_consistency(pos_label, y_true)
    # Make `y_true` a boolean vector. Use `asarray` as `y_true` could be a list
    y_true = np.asarray(np.asarray(y_true) == pos_label, dtype=np.int32)

    y_true, y_score, weight, threshold_idxs = (
        _sort_inputs_and_compute_classification_thresholds(
            y_true, y_score, sample_weight
        )
    )
    if weight is None:
        weight = 1.0

    # accumulate the true positives with decreasing threshold
    # Perform the weighted cumulative sum using float64 precision when possible
    # to avoid numerical stability problem with tens of millions of very noisy
    # predictions:
    # https://github.com/scikit-learn/scikit-learn/issues/31533#issuecomment-2967062437
    y_true = y_true.astype(np.float64)
    tps = np.cumsum(y_true * weight, dtype=np.float64)[threshold_idxs]
    if sample_weight is not None:
        # express fps as a cumsum to ensure fps is increasing even in
        # the presence of floating point errors
        fps = np.cumsum((1 - y_true) * weight, dtype=np.float64)[threshold_idxs]
    else:
        fps = 1 + threshold_idxs.astype(np.float64) - tps
    tns = fps[-1] - fps
    fns = tps[-1] - tps
    return tns, fps, fns, tps, y_score[threshold_idxs]


#
# Derived from sklearn.metrics._ranking.precision_recall_curve
#
def precision_recall_curve(
    y_true,
    y_score,
    pos_label=None,
    sample_weight=None,
    drop_intermediate=False,
):
    """Compute precision-recall pairs for different probability thresholds.

    Returns ``(precision, recall, thresholds)`` with recall decreasing, exactly
    as scikit-learn does.
    """
    _, fps, _, tps, thresholds = confusion_matrix_at_thresholds(
        y_true, y_score, pos_label=pos_label, sample_weight=sample_weight
    )

    if drop_intermediate and fps.shape[0] > 2:
        # Drop thresholds corresponding to points where true positives (tps)
        # do not change from the previous or subsequent point. This will keep
        # only the first and last point for each tps value. All points
        # with the same tps value have the same recall and thus x coordinate.
        # They appear as a vertical line on the plot.
        optimal_idxs = np.where(
            np.concatenate(
                [
                    np.asarray([True]),
                    np.logical_or(np.diff(tps[:-1]), np.diff(tps[1:])),
                    np.asarray([True]),
                ]
            )
        )[0]
        fps = fps[optimal_idxs]
        tps = tps[optimal_idxs]
        thresholds = thresholds[optimal_idxs]

    ps = tps + fps
    # Initialize the result array with zeros to make sure that precision[ps == 0]
    # does not contain uninitialized values.
    # NOTE: errstate only silences the division warning that the discarded
    # ps == 0 lane would raise; the selected values are unchanged.
    with np.errstate(divide="ignore", invalid="ignore"):
        precision = np.where(ps != 0, np.divide(tps, ps), 0.0)

    # When no positive label in y_true, recall is set to 1 for all thresholds
    # tps[-1] == 0 <=> y_true == all negative labels
    if tps[-1] == 0:
        warnings.warn(
            "No positive class found in y_true, "
            "recall is set to one for all thresholds."
        )
        recall = np.full(tps.shape, 1.0)
    else:
        recall = tps / tps[-1]

    # reverse the outputs so recall is decreasing
    return (
        np.concatenate((precision[::-1], np.asarray([1.0]))),
        np.concatenate((recall[::-1], np.asarray([0.0]))),
        thresholds[::-1],
    )


#
# Derived from
# sklearn.metrics._ranking._binary_uninterpolated_average_precision
#
def average_precision_score(y_true, y_score, pos_label=1, sample_weight=None):
    """Compute average precision (AP) from prediction scores.

    Binary targets only.  ``sklearn.metrics.average_precision_score`` routes the
    binary case straight through ``_average_binary_score`` to the uninterpolated
    binary metric, so that indirection is not reproduced here.
    """
    precision, recall, _ = precision_recall_curve(
        y_true, y_score, pos_label=pos_label, sample_weight=sample_weight
    )
    # Return the step function integral
    # The following works because the last entry of precision is
    # guaranteed to be 1, as returned by precision_recall_curve.
    # Due to numerical error, we can get `-0.0` and we therefore clip it.
    return float(max(0.0, -np.sum(np.diff(recall) * np.array(precision)[:-1])))


#
# prcbench entry point (not part of scikit-learn)
#
def prc_curve(scores, labels, pos_label=1, drop_intermediate=False, auc_type=1):
    """Calculate a precision-recall curve for prcbench.

    Parameters
    ----------
    scores : array-like
        Predicted scores.
    labels : array-like
        Observed labels.
    pos_label : scalar, default=1
        The label of the positive class.
    drop_intermediate : bool, default=False
        Passed through to ``precision_recall_curve``.
    auc_type : {1, 2}, default=1
        ``1`` for average precision (the scikit-learn recommended summary),
        ``2`` for the trapezoidal area under the precision-recall curve.

    Returns
    -------
    dict with keys ``x`` (recall, ascending), ``y`` (precision) and ``auc``.
    """
    scores = np.asarray(scores, dtype=np.float64)
    labels = np.asarray(labels)

    precision, recall, _ = precision_recall_curve(
        labels, scores, pos_label=pos_label, drop_intermediate=drop_intermediate
    )

    # scikit-learn returns recall in decreasing order; prcbench expects the
    # curve to start at the lowest recall, as the other tool wrappers do.
    x = recall[::-1]
    y = precision[::-1]

    if auc_type == 2:
        aucscore = auc(x, y)
    else:
        aucscore = average_precision_score(labels, scores, pos_label=pos_label)

    return {"x": x, "y": y, "auc": float(aucscore)}
