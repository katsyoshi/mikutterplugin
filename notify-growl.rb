# -*- coding: utf-8 -*-
require 'dl/import'

module LIBC
  extend DL::Importer
  dlload "/usr/local/lib/ao/plugins-4/libmacosx.so"
end
p LIBC.methods
