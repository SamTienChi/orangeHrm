function(title, description, note, spec, action){
    var req = {
      title: title,
      description: description,
      note: note
    };
    if (spec) req.specification = spec;
    if (action) req.currentJobSpecification = action;
    return req;
}