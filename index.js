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
//l(bin, args);
//process.exit();

var proc = child.spawn(bin, args, {
    shell: true
});
proc.stdout.on('data', function(out) {
    out = out.toString();
    l('out>> ', out);
});
proc.stderr.on('data', function(err) {
    err = err.toString();
    l('err>> ', err);
});

proc.on('exit', function(code) {
    l(c.red('extrace exited with code ' + code));
});
