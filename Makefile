VERSION=0.014

# NOTE: in order to test remote access, install RepRapCloud on another system and 
#       define 'server: <yourname>' in rrcloudrc file (in this directory)
                      
all::
	@echo "make install tests clean" 

install::
	#cp rrcloud *.cloud ~/bin/
	tar cf - rrcloud *.cloud | (cd /usr/local/bin/ && sudo tar xf -)

deinstall::
	#rm -f ~/bin/rrcloud ~/bin/*.cloud
	sudo rm -f /usr/local/bin/rrcloud /usr/local/bin/*.cloud

tests::
	rm -rf tmp; mkdir tmp
	./rrcloud --local echo tests/test.txt
	./rrcloud --local openscad tests/cube.scad
	./rrcloud --local openjscad tests/test.jscad
	./rrcloud --local slic3r tests/cube.stl
	#./rrcloud povray tests/scene.pov
	./rrcloud echo tests/test.txt
	./rrcloud openscad tests/cube.scad
	./rrcloud openjscad tests/test.jscad
	./rrcloud slic3r tests/cube.stl
	#./rrcloud openscad+slic3r tests/cube.scad
	./rrcloud info
	./openscad.cloud tests/cube.scad -otmp/cube.stl
	./openjscad.cloud tests/test.jscad -otmp/test.stl
	./slic3r.cloud --load=tests/slic3r.conf tmp/cube.stl --output=tmp/cube.gcode

clean::
	rm -rf tasks tmp

# --- developers only below

github::
	git remote set-url origin git@github.com:Spiritdude/RepRapCloud.git
	git push -u origin master

dist::	clean
	cd ..; tar cfz Backup/rrcloud-${VERSION}.tar.gz "--exclude=*.git/*" RepRapCloud/

backup::	clean
	scp ../Backup/rrcloud-${VERSION}.tar.gz the-labs.com:Backup/

edit::
	dee4 rrcloud Makefile README.md www/style.css services/*
