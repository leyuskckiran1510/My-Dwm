/* See LICENSE file for copyright and license details. */
#include <stdio.h>
#include <string.h>

#include "../util.h"

const char *
run_command(const char *cmd)
{
	char *p;
	static char temp[1024];//,str_perc[15];
	FILE *fp;
	if (!(fp = popen(cmd, "r"))) {
		warn("popen '%s':", cmd);
		return NULL;
	}
	p = fgets(buf, sizeof(buf) - 1, fp);
	if (pclose(fp) < 0) {
		warn("pclose '%s':", cmd);
		return NULL;
	}
	if (!p) {
		return NULL;
	}
	if ((p = strrchr(buf, '\n'))) {
		p[0] = '\0';
	}
	if (!strcmp("amixer sget Master | awk -F\"[][]\" '/%/ { print $2 }' | head -n1",cmd) && strcmp(temp,buf)){
		fp = popen("exec bash ~/scripts/volnotify","r");
		//popen("notify-send  'Vloume' 'Charge Now' -u normal -t 500", "r");
		pclose(fp);
		strcpy(temp,buf);
	}


	return buf[0] ? buf : NULL;
}
