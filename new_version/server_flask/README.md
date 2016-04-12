# Deploys scripts for NaviAddress-Server with ansible and AWS 
### (version 0.2)

* generate ssh keys
    ```sh
    $ ssh-keygen -t ecdsa -b 521 -C "your_email@example.com" -f ~/.ssh/navi_deploy
    ```
* add pub key as deploy key on GitHub
* cp base_vars/main.yml.example base_vars/main.yml and change it
* ansible-playbook server_flask.yml

[readme] - Instruction in confluense wiki will be late!

[readme]: https://naviworld.atlassian.net/wiki/x/OAAT