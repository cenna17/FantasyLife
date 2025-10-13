#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <limits.h>
#include <errno.h>
#include <signal.h>

#include "../include/msgs.h"

#define MAX_CMD_LEN 1024
#define MAX_ARGS 64

// Reap finished background children
void cleanup_zombies(void) {
    int status;
    while (waitpid(-1, &status, WNOHANG) > 0) {
        // silently reap zombies
    }
}

int main(void) {
    char input[MAX_CMD_LEN];
    char *args[MAX_ARGS];
    char cwd[PATH_MAX];

    while (1) {
        // Print prompt showing current directory
        if (getcwd(cwd, sizeof(cwd)) != NULL)
            printf("%s$ ", cwd);
        else
            fprintf(stderr, "shell: %s\n", GETCWD_ERROR_MSG);
        fflush(stdout);

        // Read input
        if (fgets(input, sizeof(input), stdin) == NULL) {
            printf("\n");
            break;
        }

        // Trim newline
        input[strcspn(input, "\n")] = '\0';

        // Ignore empty input
        if (strlen(input) == 0) {
            cleanup_zombies();
            continue;
        }

        // Tokenize input
        int i = 0;
        char *token = strtok(input, " ");
        while (token != NULL && i < MAX_ARGS - 1) {
            args[i++] = token;
            token = strtok(NULL, " ");
        }
        args[i] = NULL;
        if (args[0] == NULL) {
            cleanup_zombies();
            continue;
        }

        // Check background flag (&)
        int background = 0;
        if (i > 0 && strcmp(args[i - 1], "&") == 0) {
            background = 1;
            args[i - 1] = NULL;
        }

        // Built-in: exit
        if (strcmp(args[0], "exit") == 0) {
            if (args[1] != NULL) {
                fprintf(stderr, "shell: %s\n", TMA_MSG);
                continue;
            }
            exit(0);
        }

        // Built-in: pwd
        else if (strcmp(args[0], "pwd") == 0) {
            if (args[1] != NULL) {
                fprintf(stderr, "shell: %s\n", TMA_MSG);
                continue;
            }
            if (getcwd(cwd, sizeof(cwd)) != NULL)
                printf("%s\n", cwd);
            else
                fprintf(stderr, "shell: %s\n", GETCWD_ERROR_MSG);
        }

        // Built-in: cd
        else if (strcmp(args[0], "cd") == 0) {
            const char *dir = args[1];
            if (dir == NULL)
                dir = getenv("HOME");
            if (chdir(dir) != 0)
                fprintf(stderr, "shell: %s\n", CHDIR_ERROR_MSG);
        }

        // External command
        else {
            pid_t pid = fork();
            if (pid < 0) {
                fprintf(stderr, "shell: %s\n", FORK_ERROR_MSG);
                cleanup_zombies();
                continue;
            }

            if (pid == 0) {
                // Child process
                char cmdline[MAX_CMD_LEN] = "";
                for (int j = 0; args[j] != NULL; j++) {
                    strcat(cmdline, args[j]);
                    if (args[j + 1] != NULL) strcat(cmdline, " ");
                }

                execl("/bin/sh", "sh", "-c", cmdline, (char *)NULL);

                // Exec failed
                fprintf(stderr, "shell: %s\n", EXEC_ERROR_MSG);
                _exit(1);
            } else {
                // Parent process
                if (!background) {
                    if (waitpid(pid, NULL, 0) < 0)
                        fprintf(stderr, "shell: %s\n", WAIT_ERROR_MSG);
                }
                cleanup_zombies();
            }
        }
    }

    return 0;
}
