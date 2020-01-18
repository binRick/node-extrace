#!/usr/bin/env node

var async = require('async'),
    l = console.log,
    _ = require('underscore'),
    os = require('os'),
    fs = require('fs'),
    pj = require('prettyjson'),
    c = require('chalk'),
    child = require('child_process'),
    args = ['-dfltue'],
    bin = 'extrace',
    found = false,
    mysql = require('mysql'),
    connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'extrace'
    }),
    debug = process.env.DEBUG || '';

connection.connect();


var handleInsert = function(ex, _cb) {
    /*
    if (!Object.keys(ex).includes('time'))
        ex.time = '0';
    if (!Object.keys(ex).includes('username'))
        ex.username = 'UNKNOWN';
	*/
    if (debug) l(ex);
    //delete ex.line;
    if (ex.type == 'start') {
        delete ex.type;
        var query = connection.query('INSERT INTO execs SET ?', ex, function(error, results, fields) {
            _cb(error);
            if(debug)
                l(c.yellow('Inserted Row #') + c.black.bgWhite(results.insertId) + c.yellow('!'));
        });

    } else if (ex.type == 'end') {
        delete ex.type;
        var query = connection.query('UPDATE execs SET exit_code = ?, time = ?, ended_ts = NOW() where pid = ?', [ex.code, ex.time, ex.pid], function(error, results, fields) {
            _cb(error);
            if(debug)
                l(c.green('Updated Row #') + c.black.bgWhite(ex.pid) + c.green('!'));
        });
    } else {
        l(ex);
        process.exit();
    }

};

_.each(process.env.PATH.split(':'), function(d) {
    try {
        if (fs.lstatSync(d + '/' + bin).isFile()) {
            found = true;
            bin = d + '/' + bin;
        }
    } catch (e) {}
});
if (!found) {
    l(c.red('Cannot find ' + bin + ' in PATH'));
    l(process.env.PATH);
    process.exit(1);
}

if (process.getuid() != 0) {
    args.unshift(bin);
    bin = 'sudo';
}

if (debug) {
    l(bin, args.join(" "));

}

var proc = child.spawn(bin, args, {
    shell: true
});
proc.stdout.on('data', function(out) {
    out = out.toString();
    startedProcesses = [];
    endedProcesses = [];
    var outLines = out.split("\n").filter(function(o) {
        return o;
    });
    _.each(outLines, function(o) {
        pR = {};
        if (debug)
            l('out>> ', o);
        var spaceOut = o.split(' ');
        if (spaceOut[0][spaceOut[0].length - 1] == '+') {
            pR.type = 'start';
            pR.user = spaceOut[1].replace('<', '').replace('>', '');
            pR.cmd = spaceOut.slice(2, spaceOut.length).join(' ').trim();
            var te = pR.cmd.split('   '),
                pRenv1 = te[te.length - 1].split(' ');
            pR.env = {};
            _.each(pRenv1, function(pe) {
                pej = pe.split('=');
                pR.env[pej[0]] = pej[1];
            });
            pR.env = JSON.stringify(pR.env);
            pR.cmd = te.slice(0, te.length - 1).join(' ');
            pR.cwd = pR.cmd.split(' % ')[0];
            pR.cmd = pR.cmd.replace(pR.cwd + ' % ', '');
	    var buff = new Buffer(o);
	    pR.line_b64 = buff.toString('base64');
	    pR.line = buff;

        var TE_CMD = te[0].split(' ');


        var J = {
            'te_type': typeof(te),
            '_PWD': te[0].split(' ')[0],
            '_EXEC': te[0].split(' ')[2],
            '_CMD': TE_CMD.splice(2, TE_CMD.length-2).join(' '),
        }
        J._ARGS = J._CMD.split(' ').splice(1,J._CMD.split(' ').length-2).join(' ');

        pR._cmd = J._CMD;
        pR._args = J._ARGS;
        pR.exec = J._EXEC;
	    pR.json = JSON.stringify(J);
        } else if (spaceOut[0][spaceOut[0].length - 1] == '-') {
            pR.type = 'end';
            pR.exec = spaceOut[1];
            pR.code = spaceOut[3].split('=')[1];
            pR.time = spaceOut[4].split('=')[1].trim();
        } else {
            l('Unknown Output: ' + o);
            process.exit(1)
        }
        pR.pid = o.slice(0, spaceOut[0].length - 1);
        if (debug){
            l(pj.render(pR) + "\n");
        }
if(pR.cmd=='' || pR.cmd == "''"){
        if (debug){
l('  ignoring null exec..');

}else{
            handleInsert(pR, function(e) {
                if (e) throw e;
            });
}
    });
});
proc.stderr.on('data', function(err) {
    err = err.toString();
    l('err>> ', err);
});

proc.on('exit', function(code) {
    l(c.red('extrace exited with code ' + code));
});
