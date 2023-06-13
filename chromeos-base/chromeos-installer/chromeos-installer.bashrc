# unset -f cros_post_src_install_openfyde_mark_clean_overlay

cros_post_src_install_inaugural_openfyde_switch_root() {
  exeinto /usr/sbin
  doexe ${INAUGURAL_OPENFYDE_BASHRC_FILESDIR}/switch_root.sh
}

unset -f cros_pre_src_prepare_openfyde_patches

cros_pre_src_prepare_inaugural_openfyde_patches() {
  eapply -p2 ${INAUGURAL_OPENFYDE_BASHRC_FILESDIR}/postinst.patch
  eapply -p2 ${INAUGURAL_OPENFYDE_BASHRC_FILESDIR}/chromeos-install.patch
  eapply -p2 ${INAUGURAL_OPENFYDE_BASHRC_FILESDIR}/chromeos_postinst.patch
}
