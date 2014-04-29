# 
# MAKEFILE : WEB SITE
#

all:
	mkdir -p out
	mkdir -p out/shots
	cp *.css out/
	cp pics/*.* out/
	cp shots/*.* out/shots
	cp favicon3.ico out/favicon.ico
	htp -quiet index.htp         out/index.html
	htp -quiet i_download.htp    out/i_download.html
	htp -quiet i_screens.htp     out/i_screens.html
	htp -quiet doc_usage.htp     out/doc_usage.html
	htp -quiet doc_about.htp     out/doc_about.html
	htp -quiet doc_credits.htp   out/doc_credits.html
	htp -quiet doc_glossary.htp  out/doc_glossary.html
	htp -quiet doc_faq.htp       out/doc_faq.html
	htp -quiet doc_history.htp   out/doc_history.html
	htp -quiet blog_mar2008.htp  out/blog_mar2008.html
	htp -quiet blog_nov2008.htp  out/blog_nov2008.html
	htp -quiet mod_monsters.htp  out/mod_monsters.html

clean:
	rm -f out/*.*

.PHONY: all clean

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
