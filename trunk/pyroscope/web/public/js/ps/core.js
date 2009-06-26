// from http://delete.me.uk/2005/03/iso8601.html
Date.prototype.toISO8601String = function(format, offset, delim) {
    /* accepted values for the format [1-6]:
     1 Year:
       YYYY (eg 1997)
     2 Year and month:
       YYYY-MM (eg 1997-07)
     3 Complete date:
       YYYY-MM-DD (eg 1997-07-16)
     4 Complete date plus hours and minutes:
       YYYY-MM-DDThh:mmTZD (eg 1997-07-16T19:20+01:00)
     5 Complete date plus hours, minutes and seconds:
       YYYY-MM-DDThh:mm:ssTZD (eg 1997-07-16T19:20:30+01:00)
     6 Complete date plus hours, minutes, seconds and a decimal
       fraction of a second
       YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+01:00)
    */
    if (!format) { var format = 6; }
    if (!offset) {
        var offset = 'Z';
        var date = this;
    } else {
        var d = offset.match(/([-+])([0-9]{2}):([0-9]{2})/);
        var offsetnum = (Number(d[2]) * 60) + Number(d[3]);
        offsetnum *= ((d[1] == '-') ? -1 : 1);
        var date = new Date(Number(Number(this) + (offsetnum * 60000)));
    }
    if (!delim) { var delim = 'T'; }

    var zeropad = function (num) { return ((num < 10) ? '0' : '') + num; }

    var str = "";
    str += date.getUTCFullYear();
    if (format > 1) { str += "-" + zeropad(date.getUTCMonth() + 1); }
    if (format > 2) { str += "-" + zeropad(date.getUTCDate()); }
    if (format > 3) {
        str += delim + zeropad(date.getUTCHours()) +
               ":" + zeropad(date.getUTCMinutes());
    }
    if (format > 5) {
        var secs = Number(date.getUTCSeconds() + "." +
                   ((date.getUTCMilliseconds() < 100) ? '0' : '') +
                   zeropad(date.getUTCMilliseconds()));
        str += ":" + zeropad(secs);
    } else if (format > 4) { str += ":" + zeropad(date.getUTCSeconds()); }

    if (format > 3) { str += offset; }
    return str;
}


/** Get the human-readable size for an amount of bytes.
 *
 *  @param int size: the number of bytes to be converted
 *  @return string: the converted size
 */
var bibyte = function(size) {
    if (size < 1024) {
        result = size + " bytes";
    } else {
        var units = ["KiB", "MiB", "GiB"];
        for (var i = 0; i < units.length; i++) {
            size = size / 1024;
            if (size < 1024) break;
        }
        result = size.toFixed(1) + " " + units[i];
    }

    return result;
}


/** Periodically update global state in header.
 */
var stats_refresh_rate = 1000;

var stats_refresh = function() {
    var clock = document.getElementById('clock');
    var up_rate = document.getElementById('engine_up_rate');
    var down_rate = document.getElementById('engine_down_rate');
    var stats_url = '/json/engine_state';

    YAHOO.util.Connect.asyncRequest('GET', stats_url, {
        success: function(o) {
            // Trigger timer for next update
            setTimeout("stats_refresh()", stats_refresh_rate);

            // Handle response
        	if (o.responseText !== undefined) {
                // Parsing JSON strings can throw a SyntaxError exception, so we wrap the call
                // in a try catch block
                try {
                    var engine_state = YAHOO.lang.JSON.parse(o.responseText);
                }
                catch (e) {
                    YAHOO.log("Error parsing JSON from " + stats_url, "error", "stats_refresh");
                }
                if (engine_state !== undefined) {
                    var iso_date = new Date(engine_state.clock * 1000).toISO8601String(5, "+02:00", " ");
                    clock.innerHTML = iso_date.substring(0, 19);
                    up_rate.innerHTML = bibyte(engine_state.engine.up_rate);
                    down_rate.innerHTML = bibyte(engine_state.engine.down_rate);
                }
            }
        },
        failure: function(o) {
            // Trigger timer with increased delay
            setTimeout("stats_refresh()", 5*stats_refresh_rate);
        },
    }); 
};

var stats_onload = function() {
    setTimeout("stats_refresh()", 250);
}

