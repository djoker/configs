;; .emacs.d/init.el by Real Python
;; https://realpython.com/emacs-the-best-python-editor
(require 'package)
;; Adiciona o repositorio MELPA
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
;; Inicializa a infra de pacotes
(package-initialize)

;; Se Não tem nenhum pacote arquivado, atualiza
(when (not package-archive-contents)
  (package-refresh-contents))

;; Instala os pacotes
;;
;; myPackages contém uma lista de nome de pacote
(defvar myPacks
  '(better-defaults                                                 ;; Define um Emacs melhor
    elpy                                                            ;; Suporte ao Python
    flycheck                                                        ;; Sintax check on the fly
    py-autopep8                                                     ;; Faz verificação PEP8 quando salva o arquivo
    blacken                                                         ;; Formata o programa quando salva
    ein                                                             ;; Permite abrir Jupyter Notebooks
    magit                                                           ;; Integração com Git
    auto-complete                                                   ;; Duuah!
    material-theme                                                  ;; Theme
    )
  )

;; Varre a lista de pacotes de myPackages
(mapc #'(lambda (pack)
	  (unless (package-installed-p pack)
	    (package-install pack)))
      myPacks)

;;====================================
;;Customização Básica
;;====================================

(setq inhibit-startup-message t)                                    ;; Inibe tela de entrada
(load-theme 'material t)                                            ;; Carrega o Tema
(global-linum-mode t)                                               ;; Numeros de linha! Já devia ser default
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elpy-rpc-python-command "python3")
 '(package-selected-packages
   (quote
    (docker-compose-mode dockerfile-mode pipenv all-the-icons helm-gitlab helm-pydoc ## neotree material-theme better-defaults)))
 '(python-shell-interpreter "python3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 83 :width normal)))))
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;; ======================================
;; Development Setup
;; ======================================
;; Suporte ao Python
(elpy-enable)

;; Use Ipython
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter")

;; ativa  Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Ativa autoPEP8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; Ativações e setagens diversas diversas
;;NeoTree liga/desliga com F8
(global-set-key [f8] 'neotree-toggle)

;; Ativação do all-the-icons (!?!)
(require 'all-the-icons)

;; Recent files
(recentf-mode 1)
(setq recentf-max-menu-items 5)
(setq recentf-max-saved-items 5)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; Desabilita menu bar
(menu-bar-mode -1)

;; Desabilita Toolbar
(tool-bar-mode -1)

;; Configuracao de TODO
;; Tecla de atalho
(global-set-key (kbd "C-c a") 'org-agenda)

;; Especifica o arquivo que vai gravar o TODO
(setq org-agenda-files (quote ("~/.emacs.d/mmtodo.org")))

;; Informa as Prioridades (mais alta, mais baixa, padrão)
(setq org-higuest-priority ?A)
(setq org-lowest-priority ?C)
(setq org-default-priority ?A)

;; Cores para as prioridades
(setq org-priority-faces'((?A . (:foregroud "#F0FAF" :weight bold))
			  (?B . (:foregroud "LightSteelBlue"))
			  (?C . (:foregroud "OliveDrab"))))

;; Abre na janela corrente
(setq org-agenda-window-setup (quote current-window))

;; Captura itens TODO com C-c c t
(define-key global-map (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      '(( "t" "todo" entry (file+headline "~/emacs.d/mmtodo.org" "Tasks")
	  "* TODO [#A] %?")))

;; Limpa espaços no final das linhas
(add-hook 'before-save-hook 'delete-trailing-whitespace)
