$(function() {
	// automatic mask inputs with given classes
	$("input.datemask").mask("99/99/9999");
	$("input.cpf").mask("999.999.999-99");
	$("input.cep").mask("99999-999");
	$("input.phone").mask("(99) 9999-9999");
	$("input.cnpj").mask("99.999.999/9999-99");
	
	// focus first input on page
	if (!application_skip_input_focus) {
		$(":text:first").focus();
	}
});
