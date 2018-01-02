;;; grep-folder.el --- Settings for Easily Grep a folder

;; Copyright (C)
;; Author: Wanderson Ferreira <https://github.com/wandersoncferreira>
;; Package: grep-folder
;; Package-Requires: ((emacs "24.4") (ivy "0.10.0"))
;; Version: 0.1

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; grep-folder is a easy way to setting folders to be grep.
;; The idea is to configure excluded files and folders for each project you are used to grep.

;;; Code:

(require 'ivy)
(require 'grep)

;; these variables holds all the folders you want to grep and their excluded options
;; the emacs dir is setup by default without any excluded directory.
(defvar grep-folder-setup-dirs '(("~/.emacs.d" . ())))
(defvar grep-folder-setup-files '(("~/.emacs.d" . ())))

(defun grep-folder-get-all-folders ()
  "Function to get all the folder configured by the user."
  (let (folders)
    (mapc (lambda (element)
              (let ((key (car element)))
                (push key folders)))
            grep-folder-setup-dirs)
    folders))

(defun grep-folder-prepare-exclude-dirs (list-dirs)
  "Function to create the excluded directories from LIST-DIRS."
  (let (value)
    (dolist (element list-dirs value)
      (setq value (concat value " --exclude-dir=" element))
      )))

(defun grep-folder-prepare-exclude-files (list-files)
  "Function to create the excluded directories from LIST-FILES."
  (let (value)
    (dolist (element list-files value)
      (setq value (concat value " --exclude=" element)))))

;;;###autoload
(defun grep-folder ()
  "Function to help you grep your folders `grep-folder'."
  (interactive)
  (ivy-read "Folder: "
            (grep-folder-get-all-folders)
            :preselect "~/.emacs.d"
            :require-match t
            :sort t
            :action (lambda (x) (grep-folder-function x))))

(defun grep-folder-function (folder-name)
  "Function that execute the search inside the FOLDER-NAME."
  (let* ((string-search (read-string "Pattern:  "))
         (exclude-dirs (grep-folder-prepare-exclude-dirs (cdr (assoc folder-name grep-folder-setup-dirs))))
         (exclude-files (grep-folder-prepare-exclude-files (cdr (assoc folder-name grep-folder-setup-files))))
         (exclude-all (concat exclude-dirs exclude-files)))
    (grep (concat "grep --color -nrH" exclude-all " -e " string-search " " folder-name))
    (other-window 1)))

(defun grep-folder-goto-file-kill-buffer ()
  "Kill the *grep* buffer when hit C-RET."
  (interactive)
  (compile-goto-error)
  (kill-buffer "*grep*")
  (delete-other-windows))

(eval-after-load "grep"
  '(progn
     (define-key grep-mode-map (kbd "C-<return>") 'grep-folder-goto-file-kill-buffer)))

(provide 'grep-folder)
;;; grep-folder.el ends here
