(setq firsttimeinforever/separators-regexp "\\([\-'\"(){};:,.\\/?!@#%&*+=\]\\)\\|\\(\\[\\)\\|\\(\\]\\)\\|\\(\\s-\\)\\|\\(\\s_\\)\\|\\(\\`\\)\\|\\(\\'\\)\\|\\(\\^\\)\\|\\(\n\\)")

(defun firsttimeinforever/position-normalize-forward(saved-pos my-pos)
  "Normalize position after forward move"
  (if (>= (- my-pos saved-pos) 2)
	  (progn
		;;going to my-pos
		(goto-char my-pos)
		(if (not (eq my-pos (point-max)))
			(progn
			  ;;also backward-to-separator to fix position
			  (firsttimeinforever/backward-to-separator))))
	(progn
	  ;;going to my-pos in the usual way
	  (goto-char my-pos))))

(defun firsttimeinforever/forward-to-separator()
  "Move to the next separator like in the every NORMAL editor"
  (interactive "^")
  (let ((saved-pos (point))
		(my-pos (re-search-forward firsttimeinforever/separators-regexp)))
	(if (eq my-pos 1)
		(progn
		  (goto-char (+ my-pos 1))
		  (setf my-pos (re-search-forward firsttimeinforever/separators-regexp))
		  (firsttimeinforever/position-normalize-forward saved-pos my-pos))
	  (firsttimeinforever/position-normalize-forward saved-pos my-pos))
	))


(defun firsttimeinforever/position-normalize-backward(saved-pos my-pos)
  "Normalize position after backward move"
  (if (>= (- saved-pos my-pos) 2)
	  (progn
		(goto-char my-pos)
		(if (not (eq my-pos 1))
			(progn
			  (firsttimeinforever/forward-to-separator))))
	(progn
	  (goto-char my-pos))))

;;See how it works at firsttimeinforever/position-normalize-forward
(defun firsttimeinforever/backward-to-separator()
  "Move to the previous separator like in the every NORMAL editor"
  (interactive "^")
  (let ((saved-pos (point))
		(my-pos (re-search-backward firsttimeinforever/separators-regexp)))
	(if (eq my-pos (point-max))
		(progn		  
		  (goto-char (- my-pos 1))
		  (setf my-pos (re-search-backward firsttimeinforever/separators-regexp))
		  (firsttimeinforever/position-normalize-backward saved-pos my-pos))
	  (firsttimeinforever/position-normalize-backward saved-pos my-pos))
	))


(defun firsttimeinforever/position-normalize-backspace(saved-pos my-pos)
  (if (>= (- saved-pos my-pos) 2)
	  (progn
		(goto-char my-pos)
		(if (not (eq my-pos 1))
			(progn
			  (firsttimeinforever/forward-to-separator)
			  (let ((new-pos (point)))
				(delete-region new-pos saved-pos)))
		  (progn
			(delete-region 1 saved-pos))))
	(progn
	  (goto-char my-pos)
	  (let ((new-pos (point)))
		(delete-region new-pos saved-pos)))
	))

(defun firsttimeinforever/backspace-to-separator()
  "Erase characters to the first separator"
  (interactive)
  (let ((saved-pos (point))
		(my-pos (re-search-backward firsttimeinforever/separators-regexp)))
	(if (eq my-pos (point-max))
		(progn
		  (goto-char (- my-pos 1))
		  (setf my-pos (re-search-backward firsttimeinforever/separators-regexp))
		  (firsttimeinforever/position-normalize-backspace saved-pos my-pos))
	  (firsttimeinforever/position-normalize-backspace saved-pos my-pos))
	))



;; (defun proper-cursor-move-global-mode()
;;   (interactive)
;;   (global-set-key (kbd "C-<right>") 'firsttimeinforever/forward-to-separator)
;;   (global-set-key (kbd "C-<left>") 'firsttimeinforever/backward-to-separator)
;;   (global-set-key (kbd "C-<backspace>") 'firsttimeinforever/backspace-to-separator))

;; (defun proper-cursor-move-mode()
;;   (interactive)
;;   (local-set-key (kbd "C-<right>") 'firsttimeinforever/forward-to-separator)
;;   (local-set-key (kbd "C-<left>") 'firsttimeinforever/backward-to-separator)
;;   (local-set-key (kbd "C-<backspace>") 'firsttimeinforever/backspace-to-separator))

(setq proper-cursor-move-mode-keymap (let ((map (make-sparse-keymap)))
									   (define-key map (kbd "C-<right>") 'firsttimeinforever/forward-to-separator)
									   (define-key map (kbd "C-<left>") 'firsttimeinforever/backward-to-separator)
									   (define-key map (kbd "C-<backspace>") 'firsttimeinforever/backspace-to-separator)
									   map))

(define-minor-mode proper-cursor-move-global-mode
  "Your cursor movement is too bad, so you use this mode globally"
  :lighter " prop-cursor-move"
  :global t
  :keymap proper-cursor-move-mode-keymap)

(define-minor-mode proper-cursor-move-mode
  "Your cursor movement sucks, so you use this mode"
  :lighter " prop-cursor-move"
  :keymap proper-cursor-move-mode-keymap)

(provide 'proper-cursor-move-global-mode)
(provide 'proper-cursor-move-mode)
