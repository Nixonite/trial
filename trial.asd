#|
 This file is a part of trial
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:cl-user)
(asdf:defsystem trial
  :version "1.2.0"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :license "Artistic"
  :description "A flexible and extensible video game engine."
  :homepage "https://github.com/Shirakumo/trial"
  :serial T
  :components ((:file "package")
               (:file "features")
               (:file "toolkit")
               (:file "transforms")
               (:file "entity")
               (:file "savestate")
               (:file "layer-set")
               (:file "window")
               (:file "fullscreenable")
               (:file "renderable")
               (:file "context")
               (:file "display")
               (:file "asset")
               (:file "asset-pool")
               (:file "geometry")
               (:file "helpers")
               (:file "event-loop")
               (:file "executable")
               (:file "subject")
               (:file "shader-subject")
               (:file "subjects")
               (:file "scene")
               (:file "shader-pass")
               (:file "pipeline")
               (:file "hud")
               (:file "sprite")
               (:file "skybox")
               (:file "octree")
               (:file "camera")
               (:file "selectable")
               (:file "flare")
               (:file "mapping")
               (:file "retention")
               (:file "input-tables")
               (:file "input")
               (:file "player")
               (:file "controller")
               (:file "main")
               (:file "launcher")
               (:file "deploy"))
  :depends-on (:alexandria
               :3d-vectors
               :3d-matrices
               :verbose
               :qtools
               :qtcore
               :qtgui
               :qtopengl
               :cl-opengl
               :closer-mop
               :trivial-garbage
               :bordeaux-threads
               :wavefront-loader
               :cl-gamepad
               :cl-monitors
               :pathname-utils
               :flare
               :qtools-ui-slider
               :for
               :glsl-toolkit))
