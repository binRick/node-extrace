module.exports = {
    cg_index: {
     prefix: 'NODE_EXTRACE',
     cmds: {
      create: 'command cgcreate -a root:root -t root:root -g cpu,cpuacct,memory,pids,blkio:NODE_EXTRACE',
      classify: 'command cgclassify -g cpu,memory:NODE_EXTRACE ' + String(process.pid),
     },
    },   
    cg_prefix: 'EXTRACE_',
    cg_execs: [
    ],
};
