TOP=../..
##############################################################################
# Variables
##############################################################################
TARGET=lib
OPAMPKG=pfff-lang_python

-include $(TOP)/Makefile.config

SRC= ast_python.ml meta_ast_python.ml \
     visitor_python.ml \
     lib_parsing_python.ml \
     parser_python.ml lexer_python.ml \
     token_helpers_python.ml \
     parse_python.ml \
     test_parsing_python.ml unit_parsing_python.ml

SYSLIBS= str.cma unix.cma 

LIBS=$(TOP)/commons/lib.cma \
 $(TOP)/h_program-lang/lib.cma \

INCLUDEDIRS= $(TOP)/commons \
  $(TOP)/commons_core \
  $(TOP)/globals \
  $(TOP)/h_program-lang \

##############################################################################
# Generic variables
##############################################################################
-include $(TOP)/Makefile.common

##############################################################################
# Top rules
##############################################################################
all:: $(TARGET).cma
all.opt:: $(TARGET).cmxa

$(TARGET).cma: $(OBJS)
	$(OCAMLC) -a -o $(TARGET).cma $(OBJS)
$(TARGET).cmxa: $(OPTOBJS) $(LIBS:.cma=.cmxa)
	$(OCAMLOPT) -a -o $(TARGET).cmxa $(OPTOBJS)
$(TARGET).top: $(OBJS) $(LIBS)
	$(OCAMLMKTOP) -o $(TARGET).top $(SYSLIBS) $(LIBS) $(OBJS)

clean::
	rm -f $(TARGET).top


lexer_python.ml: lexer_python.mll
	$(OCAMLLEX) $<
clean::
	rm -f lexer_python.ml
beforedepend:: lexer_python.ml


parser_python.ml parser_python.mli: parser_python.mly
	$(OCAMLYACC) $<
clean::
	rm -f parser_python.ml parser_python.mli parser_python.output
beforedepend:: parser_python.ml parser_python.mli

visitor_python.cmo: visitor_python.ml
	ocamlc $(INCLUDES) -w y -c $<
