#cloud-config

users:
  - name: wabadmin
    lock_passwd: false
    plain_text_passwd: ${wabadmin_password}
  - name: wabsuper   
    lock_passwd: false
    plain_text_passwd: ${wabsuper_password}
  - name: wabupgrade
    lock_passwd: false
    plain_text_passwd: ${wabupgrade_password}
preserve_hostname: False
manage_etc_hosts: localhost