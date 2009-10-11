module WorkElementsHelper
	def grid(options)
		return if options[:model].nil?

		model=options[:model]
		ignore_list=['id','created_at','updated_at']
		ignore_list<<options[:ignore_list] unless options[:ignore_list]
		model_class=model[0].class
		cols=model_class.columns.length
		rows=model.length
		table='<table border="1" cellpadding="0">'
		table << "<tr>"
		model_class.columns.each do |c|
			next if ignore_list.index c.name
			table << "<th>#{c.name}</th>"
		end
		table << "</tr>"
		1.upto rows do |r|
			table << "<tr>"
			model_class.columns.each do |c|
				next if ignore_list.index c.name
				id=model[r-1].id
				value=model[r-1].send c.name
				table << <<-END_OF_HTML
<td>
	<input 
		id="#{c.name}#{r}" 
		style="border:none;"
		type="text"
		onkeydown="_handle_keyboard(event,#{id},'#{c.name}',#{r},#{rows})"
		onfocus="store_original_value(this)"
		onBlur="update_if_required(this,#{id},'#{c.name}')"
		value='#{value}'>
	</input>
</td>
			END_OF_HTML
			end
			table << "</tr>"
		end
		table << "</table>"
		table << <<-END_OF_SCRIPT
<script language="JavaScript">
var _original_value;
var _original_node;
function _handle_keyboard(e,id,column,r,max_r){
	var code=e.keyCode;
	var old_r=r;
	var id="";
	if(code==40){ //down
		r=r+1;
		if(r>max_r)r=1;
	}
	if(code==38){//up
		r=r-1;
		if(r<1)r=1;
	}
	if(code==27){ //escape
		setTimeout(restore_original_value,0);
	}

	if(old_r!=r){
		id=column+""+r;
		var element=document.getElementById(id);
		if(element!=null)element.focus();
	}
}
function restore_original_value(){
	_original_node.value=_original_value;

}
function store_original_value(node){
	_original_value=node.value;
	_original_node=node;
}
function update_if_required(node,id,col_name){
	if(node.value==_original_value) return;
	new Ajax.Updater(
			'inbox_status', 
			'/work_elements/dingo/'+id, 
			{asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('Hl7TS7DG2dM0zmGAO09HMU8rKTNJwto37APahAPK9vA=')}
			)
}
</script>
		END_OF_SCRIPT
	end
end

#<a href="#" onclick="new Ajax.Updater('inbox_status', '/work_elements/dingo', {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('Hl7TS7DG2dM0zmGAO09HMU8rKTNJwto37APahAPK9vA=')}); return false;">Check status...</a>

