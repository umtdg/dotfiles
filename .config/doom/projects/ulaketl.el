;;; ulaketl.el -*- lexical-binding: t; -*-

((python-mode . ((eglot-server-programs
                  . (((python-mode python-ts-mode) . ("ty" "server"))))
                 (flycheck-checker . python-ruff)
                 (apheleia-formatter . (ruff-isort ruff)))))
