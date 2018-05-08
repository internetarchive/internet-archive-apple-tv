import ATV from 'atvjs';

var BASE_URL = 'https://archive.org/';

var API = function(){
}

API.Search = function(query, options, success, fail){
    var str_option = '&output=json';
    for (var key in options) {
        str_option += '&' + key + '=' + options[key];
    }
    var url = encodeURI(BASE_URL + 'advancedsearch.php?q=' + query + str_option);

    ATV.Ajax.get(url).then((xhr) => {
        success(xhr.response);
    }, (err) => {
        fail(err);
    });
}

API.GetCollections = function(collection, result_type, num, success, fail){
    var options = {
        'rows': '1',
        'fl[]' : 'identifier,title,year,downloads,week'
    };

    if (num) options['rows'] = num.toString();

    API.Search(
        'collection:(' + collection + ') AND mediatype:' + result_type,
        options,
        function(data){
            console.log("API.GetCollections, Response Data-", data);
            if (!num) {
                if (data.response.numFound == 0) {
                    console.log('API.GetCollections - fail');
                    fail(data);
                } else {
                    console.log('API.GetCollections - recall');
                    API.GetCollections(collection, result_type, data.response.numFound, success, fail);
                }
            } else {
                // if (num == data.response.numFound) {
                //     success(collection, data.response.docs.sort(function(a, b){
                //         return parseInt(b.downloads) - parseInt(a.downloads);
                //     }));
                // } else {
                //     fail(data);
                // }
                success(collection, data.response.docs.sort(function(a, b){
                    return parseInt(b.downloads) - parseInt(a.downloads);
                }));
            }
        },
        function(err){
            fail(err);
        });
}

API.GetMetaData = function(identifier, success, fail){
    var url = encodeURI(BASE_URL + 'metadata/' + identifier);

    ATV.Ajax.get(url).then((xhr) => {
        success(xhr.response);
    }, (err) => {
        fail(err);
    });
}

export default API;