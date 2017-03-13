#|
 This file is a part of trial
 (c) 2017 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)
(in-readtable :qtools)

;; FIXME: inline and compiler-macro things to make it more efficient

(defvar *view-matrix* (meye 4))
(defvar *projection-matrix* (meye 4))
(defvar *model-matrix-stack* (list (meye 4)))

(declaim (inline view-matrix (cl:setf view-matrix)
                 projection-matrix (cl:setf projection-matrix)
                 model-matrix (cl:setf model-matrix)
                 push-matrix pop-matrix
                 translate translate-by
                 rotate rotate-by
                 scale scale-by))
(defun view-matrix ()
  *view-matrix*)

(defun (cl:setf view-matrix) (mat4)
  (setf *view-matrix* mat4))

(defun projection-matrix ()
  *projection-matrix*)

(defun (cl:setf projection-matrix) (mat4)
  (setf *projection-matrix* mat4))

(defun look-at (eye target up)
  (setf *view-matrix* (mlookat eye target up)))

(defun perspective-projection (fovy aspect near far)
  (setf *projection-matrix* (mperspective fovy aspect near far)))

(defun orthographic-projection (left right bottom top near far)
  (setf *projection-matrix* (mortho left right bottom top near far)))

(defun model-matrix ()
  (first *model-matrix-stack*))

(defun (cl:setf model-matrix) (mat4)
  (setf (first *model-matrix-stack*) mat4))

(defun push-matrix (&optional (matrix (mcopy4 (model-matrix))))
  (push matrix *model-matrix-stack*))

(defun pop-matrix ()
  (pop *model-matrix-stack*)
  ;; Make sure we can't pop too far
  (unless *model-matrix-stack*
    (setf *model-matrix-stack* (list (meye 4)))))

(defmacro with-pushed-matrix (&body body)
  `(progn (push-matrix)
          (unwind-protect
               (progn ,@body)
            (pop-matrix))))

(defun translate (v &optional (matrix (model-matrix)))
  (nmtranslate matrix v))

(defun translate-by (x y z &optional (matrix (model-matrix)))
  (translate (vec3 x y z) matrix))

(defun rotate (v angle &optional (matrix (model-matrix)))
  (nmrotate matrix v angle))

(defun rotate-by (x y z angle &optional (matrix (model-matrix)))
  (rotate (vec3 x y z) angle matrix))

(defun scale (v &optional (matrix (model-matrix)))
  (nmscale matrix v))

(defun scale-by (x y z &optional (matrix (model-matrix)))
  (scale (vec3 x y z) matrix))

(defun reset-matrix (&optional (matrix (model-matrix)))
  (with-fast-matref (a matrix 4)
    (setf (a 0 0) 1.0 (a 0 1) 0.0 (a 0 2) 0.0 (a 0 3) 0.0
          (a 1 0) 0.0 (a 1 1) 1.0 (a 1 2) 0.0 (a 1 3) 0.0
          (a 2 0) 0.0 (a 2 1) 0.0 (a 2 2) 1.0 (a 2 3) 0.0
          (a 3 0) 0.0 (a 3 1) 0.0 (a 3 2) 0.0 (a 3 3) 1.0)
    matrix))

(defun vec->screen (vec width height)
  (let ((clip-pos (m* (projection-matrix) (view-matrix) (model-matrix) (vxyz_ vec))))
    (let ((w (vw clip-pos)))
      (if (= 0.0s0 w)
          (vec -1 -1 0)
          (let* ((norm-pos (nv+ (nv* (vxyz clip-pos) (/ 0.5s0 w)) 0.5s0)))
            (vsetf norm-pos
                   (* width (vx norm-pos))
                   (* height (- 1 (vy norm-pos)))
                   0.0s0))))))

(defun screen->vec (vec width height)
  (let ((x (1- (* 2 (/ (vx vec) width))))
        (y (1- (* 2 (/ (vy vec) height))))
        (inv (minv (m* (projection-matrix) (view-matrix) (model-matrix)))))
    (m* inv (vec4 x y 0 0))))

(defun vec->main (vec main)
  (vec->screen vec (q+:width main) (q+:height main)))

(defun main->vec (vec main)
  (screen->vec vec (q+:width main) (q+:height main)))