# aliases to mov inventory
alias rsync-inventory='rsync -avz --delete --progress \
                        --exclude  "venvs" \
                        --exclude ".env" \
                        --exclude  "__pychache__" \
                        ~/project/Inventory/. awampler-desk:project/Inventory/.'
alias rsync-inventory-test='rsync-inventory -n'

                            #--exclude "*.git" \
alias rsync-inventory-back='rsync -azv --progress \
                            --exclude "venvs" \
                            --exclude ".env" \
                            --exclude "*.pyc" \
                            --exclude "__pycache__" \
                            awampler-desk:project/Inventory/. /Users/awampler/project/Inventory/'
alias rsync-inventory-back-test='rsync-inventory-back -n'
