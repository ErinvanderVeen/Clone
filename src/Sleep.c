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
	char buf[1024];
	struct timeval timeout_val;
	int cl, s_rc, rc;
	char* result = NULL;

	fd_set readfds;

	// Set timeout
	timeout_val.tv_sec = timeout;
	timeout_val.tv_usec = 0;

	FD_ZERO(&readfds);

	FD_SET(socket_fd, &readfds);

	if ((s_rc = select(socket_fd + 1, &readfds, NULL, NULL, &timeout_val)) == -1) {
		return NULL;
	} else if (s_rc == 0) {
		// Timeout was reached, return empty string
		return "";
	} else {
		if ((cl = accept(socket_fd, NULL, NULL)) == -1) {
			return NULL;
		}

		while ((rc = read(cl,buf,sizeof(buf))) > 0) {
			result = realloc(result, sizeof(result) + rc + 1);
			strcat(result, buf);
		}
		if (rc == -1) {
			return NULL;
		} else if (rc == 0) {
			close(cl);
			return result;
		}
	}
}