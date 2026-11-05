# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config

import std/[compilesettings, strutils]

const DefaultClang = defined(macosx) or defined(freebsd) or defined(openbsd) or defined(netbsd)

proc usesClang(): bool =
  let args = querySetting(SingleValueSetting.commandLine)
  if "--cc:clang" in args: true
  elif "--cc:gcc" in args: false
  else: DefaultClang

when defined(release) or defined(danger):
  if usesClang():
    switch("passC", "-fstack-protector-strong -fstack-clash-protection")
  else:
    switch("passC", "-fhardened")
