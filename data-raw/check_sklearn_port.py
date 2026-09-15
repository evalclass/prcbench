"""Verify inst/python/prcbench_sklearn.py against real scikit-learn.

This is a development-only script.  It is NOT part of the package and is not
run by ``R CMD check`` -- ``data-raw`` is listed in ``.Rbuildignore``.

The vendored module in ``inst/python/prcbench_sklearn.py`` is a standalone port
of scikit-learn's precision-recall curve logic.  This script is the evidence
that the port preserved the original behaviour.

Usage::

    python -m venv /tmp/skref
    /tmp/skref/bin/pip install scikit-learn numpy
    /tmp/skref/bin/python data-raw/check_sklearn_port.py
"""

import os
import sys

import numpy as np

sys.path.insert(
    0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "inst", "python")
)

import prcbench_sklearn as port  # noqa: E402

from sklearn.metrics import average_precision_score as sk_ap  # noqa: E402
from sklearn.metrics import precision_recall_curve as sk_prc  # noqa: E402

FAILURES = []


def check(name, labels, scores, pos_label=None, drop_intermediate=False):
    kwargs = {"drop_intermediate": drop_intermediate}
    if pos_label is not None:
        kwargs["pos_label"] = pos_label

    try:
        sk_p, sk_r, sk_t = sk_prc(labels, scores, **kwargs)
    except Exception as exc:  # the port must fail the same way
        try:
            port.precision_recall_curve(labels, scores, **kwargs)
        except Exception:
            print("  ok   {} (both raised)".format(name))
            return
        FAILURES.append("{}: sklearn raised {!r}, port did not".format(name, exc))
        print("  FAIL {} (only sklearn raised)".format(name))
        return

    pt_p, pt_r, pt_t = port.precision_recall_curve(labels, scores, **kwargs)

    problems = []
    for label, a, b in (
        ("precision", sk_p, pt_p),
        ("recall", sk_r, pt_r),
        ("thresholds", sk_t, pt_t),
    ):
        a = np.asarray(a, dtype=np.float64)
        b = np.asarray(b, dtype=np.float64)
        if a.shape != b.shape:
            problems.append("{} shape {} != {}".format(label, a.shape, b.shape))
        elif not np.allclose(a, b, rtol=1e-12, atol=1e-12, equal_nan=True):
            problems.append(
                "{} max abs diff {:g}".format(label, np.max(np.abs(a - b)))
            )

    # average precision
    ap_kwargs = {"pos_label": pos_label} if pos_label is not None else {}
    try:
        sk_ap_val = sk_ap(labels, scores, **ap_kwargs)
        pt_ap_val = port.average_precision_score(
            labels, scores, **(ap_kwargs or {"pos_label": 1})
        )
        if not np.allclose(sk_ap_val, pt_ap_val, rtol=1e-12, atol=1e-12, equal_nan=True):
            problems.append("AP {:.17g} != {:.17g}".format(sk_ap_val, pt_ap_val))
    except Exception as exc:
        problems.append("AP comparison errored: {!r}".format(exc))

    if problems:
        FAILURES.append("{}: {}".format(name, "; ".join(problems)))
        print("  FAIL {}: {}".format(name, "; ".join(problems)))
    else:
        print("  ok   {}".format(name))


def main():
    rng = np.random.RandomState(42)

    print("random inputs")
    for n in (2, 5, 10, 100, 1000):
        for trial in range(5):
            labels = rng.randint(0, 2, n)
            scores = rng.rand(n)
            if len(np.unique(labels)) < 2:
                continue
            check("random n={} trial={}".format(n, trial), labels, scores)

    print("tied scores (the stable-sort case)")
    check("all tied", np.array([0, 1, 0, 1]), np.array([0.5, 0.5, 0.5, 0.5]))
    check("some tied", np.array([0, 1, 1, 0, 1]), np.array([0.2, 0.2, 0.8, 0.8, 0.5]))
    check(
        "many ties",
        rng.randint(0, 2, 200),
        rng.randint(0, 5, 200) / 5.0,
    )
    check(
        "ties reversed order",
        np.array([1, 0, 1, 0, 1, 0]),
        np.array([0.9, 0.9, 0.9, 0.1, 0.1, 0.1]),
    )

    print("degenerate label distributions")
    check("all positive", np.array([1, 1, 1, 1]), np.array([0.1, 0.4, 0.35, 0.8]))
    check("all negative", np.array([0, 0, 0, 0]), np.array([0.1, 0.4, 0.35, 0.8]))
    check("single element positive", np.array([1]), np.array([0.5]))
    check("single element negative", np.array([0]), np.array([0.5]))
    check("two elements", np.array([0, 1]), np.array([0.3, 0.7]))

    print("pos_label handling")
    check("pos_label=2", np.array([1, 2, 1, 2]), np.array([0.1, 0.9, 0.4, 0.6]), pos_label=2)
    check("pos_label=1 of {1,2}", np.array([1, 2, 1, 2]), np.array([0.1, 0.9, 0.4, 0.6]), pos_label=1)
    check("labels -1/1", np.array([-1, 1, -1, 1]), np.array([0.1, 0.9, 0.4, 0.6]))

    print("drop_intermediate")
    for trial in range(5):
        labels = rng.randint(0, 2, 100)
        scores = rng.rand(100)
        check("drop_intermediate trial={}".format(trial), labels, scores, drop_intermediate=True)
    check(
        "drop_intermediate flat",
        np.array([0, 0, 0, 1, 1, 1, 0, 0]),
        np.arange(8) / 8.0,
        drop_intermediate=True,
    )

    print("negative and large scores")
    check("negative scores", rng.randint(0, 2, 50), rng.randn(50))
    check("large scores", rng.randint(0, 2, 50), rng.randn(50) * 1e6)
    check("tiny scores", rng.randint(0, 2, 50), rng.randn(50) * 1e-8)

    print("prc_curve entry point (recall ascending, auc types)")
    labels = rng.randint(0, 2, 50)
    scores = rng.rand(50)
    res = port.prc_curve(scores, labels, auc_type=1)
    sk_p, sk_r, _ = sk_prc(labels, scores)
    if not np.allclose(res["x"], sk_r[::-1]):
        FAILURES.append("prc_curve: x is not reversed sklearn recall")
    if not np.allclose(res["y"], sk_p[::-1]):
        FAILURES.append("prc_curve: y is not reversed sklearn precision")
    if not np.all(np.diff(res["x"]) >= 0):
        FAILURES.append("prc_curve: x is not ascending")
    if not np.allclose(res["auc"], sk_ap(labels, scores)):
        FAILURES.append("prc_curve: auc_type=1 does not match average_precision_score")
    res2 = port.prc_curve(scores, labels, auc_type=2)
    if not np.allclose(res2["auc"], port.auc(res2["x"], res2["y"])):
        FAILURES.append("prc_curve: auc_type=2 does not match trapezoid auc")
    print("  ok   prc_curve" if not FAILURES else "  see failures below")

    print()
    if FAILURES:
        print("{} FAILURE(S):".format(len(FAILURES)))
        for failure in FAILURES:
            print("  - {}".format(failure))
        return 1
    print("All checks passed: the port matches scikit-learn.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
