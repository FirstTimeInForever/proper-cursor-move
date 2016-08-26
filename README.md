***Proper cursor move mode***
===
So you start using Emacs and you actually loved it. But if you always use ```C-<left>``` ```C-<right>``` and ```C-<backspace>``` you might have noticed that it works not like you expect. Instead of moving to the next `separator` it moves to the next `word`	(it is bound to `forward-word` and `backward-word`). 

**It is totally unusable. **
----

So I made this minor mode to solve the issue.
===
You can see the difference at these gifs:

![Proper cursor mode enabled](/img/enabled.gif)

![Proper cursor mode disabled](/img/disabled.gif)


## Usage##
Put ```proper-cursor-move-mode.el``` to your ```.emacs.d``` directory. 
Add this line to your ```.emacs``` 
		

    (add-to-list 'load-path "~/.emacs.d")
    (require 'proper-cursor-move-mode)

Use ```M-x proper-cursor-move-mode``` to enable proper cursor move mode in current buffer.
Or you can enable it globally by using ```M-x proper-cursor-global-mode```
