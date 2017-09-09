/* In order to keep linking with C as pure as possible, everything related to time is handled in
 * Clean. This C program does not consider how much time is left to wait. It simply returns
 * whatever the socket received (which is empty if no process attempted an interrupt).
 */
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <stdio.h>
#include <sys/time.h>
#include <stdlib.h>
#include <unistd.h>

int create_socket() {
	const char* sock_name = "./ipc_socket";
	struct sockaddr_un addr;
	int socket_fd;

	socket_fd = socket(AF_UNIX, SOCK_STREAM, 0);
	if (socket_fd < 0) {
		return -1;
	}

	addr.sun_family = AF_UNIX;
	strcpy(addr.sun_path, sock_name);
	unlink(addr.sun_path);

	if (bind(socket_fd, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
		return -1;
	}

	if (listen(socket_fd, 5) == -1) {
		return -1;
	}

	return socket_fd;
}

char* wait(unsigned int timeout, int socket_fd) {
	char buf[256];
	struct timeval timeout_val;
	int cl, s_rc, rc;
	// malloc(0) to prevent sizeof() to return 8
	char* result = malloc(0);

	fd_set readfds;

	// Set timeout
	timeout_val.tv_sec = timeout;
	timeout_val.tv_usec = 0;

	FD_ZERO(&readfds);

	FD_SET(socket_fd, &readfds);

	int string_length = 0;

	if ((s_rc = select(socket_fd + 1, &readfds, NULL, NULL, &timeout_val)) == -1) {
		return NULL;
	} else if (s_rc == 0) {
		// Timeout was reached, return empty string
		return "";
	} else {
		if ((cl = accept(socket_fd, NULL, NULL)) == -1) {
			return NULL;
		}

		// TODO: Determine what to do if transmission takes longer
		// than the timeoutval
		while ((rc = read(cl,buf,sizeof(buf))) > 0) {
			if(sizeof(result) < string_length + rc + 1) {
				result = realloc(result, string_length + rc + 1);
			}
			strncpy(&result[string_length], buf, rc);
			string_length += rc;
			result[string_length] = '\0';
		}
		
		if (rc == -1) {
			return NULL;
		} else if (rc == 0) {
			close(cl);
			return result;
		}
	}
}
