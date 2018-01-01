# grep-folder
Emacs small package to help you grep your folders and correct configure it


# Instillation

``` emacs-lisp
(add-to-list 'load-path "~/.emacs.d/site-packages/grep-folder")
(require 'grep-folder)
(global-set-key (kbd "C-c g") 'grep-folder)
```

# Usage

After the installation you only need to fire `M-x grep-folder` and select the folder you want to grep.


![Example](ivy-interface.png)


By default there is only the `emacs.d` folder setup. Check how to add and customize the folder you desire below.


# Customization

The settings below remove the `var/`, `etc/`, `.cask/`, `.git/` and `site-packages` from the grep command inside my `emacs.d` directory.
It also adds the `myScript` folder to the initial menu.
``` emacs-lisp
(setq grep-folder-setup-dirs '(("~/.emacs.d" . ("var/" "etc/" ".cask/" ".git/" "site-packages"))
                               ("~/myScripts")))
(setq grep-folder-setup-files '(("~/.emacs.d" . (".gitmodules"))))
```



