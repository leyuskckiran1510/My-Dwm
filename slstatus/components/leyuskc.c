static int state_ac = 0;
		static char states[50]="";
		int perc;
		size_t i;
		char path[PATH_MAX], state[12];;
		if (esnprintf(path, sizeof(path),
		              "/sys/class/power_supply/%s/capacity", bat) < 0) {
			;
		}
		if (pscanf(path, "%d", &perc) != 1) {
			;
		}
		perc=perc/11;
		static struct {
			char *state;
			char symbol;
		} map[] = {
			{ "Charging",states[state_ac%9]},
			{ "Discharging",states[perc] },
			{"FULL",''},
		};
		state_ac+=1;
