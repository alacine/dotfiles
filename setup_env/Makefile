neovim.tar.gz: plugged.tar plug.vim config.tar tmux.conf fzf
	tar -zcf neovim.tar.gz plugged.tar plug.vim config.tar Makefile tmux.conf fzf
	rm -rf ./plug.vim ./plugged.tar ./config.tar

tmux.conf:
	cp ~/.tmux.conf ./tmux.conf

plugged.tar:
	tar -cf plugged.tar -C ~/.vim/ plugged

plug.vim:
	wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

config.tar:
	tar -cf config.tar -C ~/Code/dotfiles nvim

fzf:
	wget https://github.com/junegunn/fzf/releases/download/0.28.0/fzf-0.28.0-linux_amd64.tar.gz
	tar -zxvf fzf-0.28.0-linux_amd64.tar.gz

.PHONY: clean
clean:
	rm -rf ./*.tar ./*.tar.gz ./plug.vim ./tmux.conf

.PHONY: docker
docker:
	docker build . -t neovim 

.PHONY: install
install:
	@echo "current not support coc extensions"
	if [ ! -d ~/.vim ]; then \
		mkdir -p ~/.vim; \
	fi
	tar -xf plugged.tar -C ~/.vim
	if [ ! -d ~/.config ]; then \
		mkdir -p ~/.config; \
	fi
	tar -xf config.tar -C ~/.config
	if [ ! -d ~/.local/share/nvim/site/autoload ]; then \
		mkdir -p ~/.local/share/nvim/site/autoload; \
	fi
	install plug.vim ~/.local/share/nvim/site/autoload
	install tmux.conf ~/.tmux.conf
	install fzf ~/.vim/plugged/fzf/bin/

.PHONY: uninstall
uninstall:
	if [ -d ~/.vim/plugged ]; then \
		rm -rf ~/.vim/plugged/; \
	fi
	if [ -d ~/.config ]; then \
		rm -rf ~/.config/nvim; \
	fi
	if [ -e ~/.local/share/nvim/site/autoload/plug.vim ]; then \
		rm -f ~/.local/share/nvim/site/autoload/plug.vim
	fi
