#!/usr/bin/env node

var async = require('async'),
    l = console.log,
    _ = require('underscore'),
    os = require('os'),
    fs = require('fs'),
    c = require('chalk'),
    child = require('child_process'),
    args = ['-dfltu'],
    bin = 'extrace',
    found = false;

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

var proc = child.spawn(bin, args, {
    shell: true
});
proc.stdout.on('data', function(out) {
    out = out.toString();
    startedProcesses = [];
    endedProcesses = [];
    _.each(out.split("\n"), function(o) {
        pR = {};
        l('out>> ', out);
        var spaceOut = out.split(' ');
        if (spaceOut[0][spaceOut[0].length - 1] == '+') {
            pR.type = 'start';
            pR.user = spaceOut[1].replace('<', '').replace('>', '');
            pR.cmd = spaceOut.slice(2, spaceOut.length).join(' ').trim();
        } else if (spaceOut[0][spaceOut[0].length - 1] == '-') {
            pR.type = 'end';
            pR.exec = spaceOut[1];
            pR.code = spaceOut[3].split('=')[1];
            pR.time = spaceOut[4].split('=')[1].trim();
        } else {
            l('Unknown Output: ' + out);
            process.exit(1)
        }
        pR.pid = out.slice(0, spaceOut[0].length - 1);
        l(pR);
    });
});
proc.stderr.on('data', function(err) {
    err = err.toString();
    l('err>> ', err);
});

proc.on('exit', function(code) {
    l(c.red('extrace exited with code ' + code));
});
