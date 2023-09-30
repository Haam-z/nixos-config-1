(setq user-full-name "Haam"
      user-mail-address "hamzazarouk@gmail.com")
(setq doom-theme 'doom-tokyo-night)
(setq doom-font (font-spec :family "Fira Code Nerd Font" :size 18 :weight 'bold)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 13))
(setq display-line-numbers-type 'relative)
(add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)
