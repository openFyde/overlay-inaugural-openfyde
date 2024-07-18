# unset -f cros_post_src_install_openfyde_mark_clean_overlay

cros_post_src_install_inaugural_openfyde_switch_root() {
  exeinto /usr/sbin
  doexe ${INAUGURAL_OPENFYDE_BASHRC_FILESDIR}/switch_root.sh
}

unset -f cros_pre_src_prepare_openfyde_patches

cros_pre_src_prepare_inaugural_openfyde_patches() {
  if [ $PV == "9999" ]; then
    return
  fi
  eapply  ${INAUGURAL_OPENFYDE_BASHRC_FILESDIR}/001-add-support-for-uboot.patch
  eapply  ${INAUGURAL_OPENFYDE_BASHRC_FILESDIR}/002-update-resize-and-overlayfs.patch
}
