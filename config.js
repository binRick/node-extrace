module.exports = {
    cg_index: {
     prefix: 'NODE_EXTRACE',
     cmds: {
      create: 'cgcreate -a root:root -t root:root -g cpu,cpuacct,memory,pids,blkio:NODE_EXTRACE',
     },
    },   
    cg_prefix: 'EXTRACE_',
    cg_execs: [
    ],
};
