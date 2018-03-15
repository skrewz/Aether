.PHONY: all_parts clean
        
all_parts: ActualFinalChorder-part-thumb_plate.stl \
  ActualFinalChorder-part-glove.stl \
  ActualFinalChorder-part-finger_plate.stl

%.stl: ActualFinalChorder.scad
	@# http://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment
	openscad $(shell  echo "$@" | sed -re "s/.*-part-([^-.]+).*/ -D'render_part=\"\1\"'/") -o $@ $<
        
clean:
	@rm -f *.stl
