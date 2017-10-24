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

/**
 * Data that doesn't need to be reset after every call
 */
// Temporary storage of interrupt input
char buf[256];

// Used to timeout select
struct timeval timeout_val;

// Return codes
int cl, s_rc, rc;

// Pointer to result string in memory
char* result;

// Set of the only filedescriptor
fd_set readfds;

// Used to remember how long the result string currently is
int string_length;

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

void setup_socket(int socket_fd) {

	FD_ZERO(&readfds);

	FD_SET(socket_fd, &readfds);

	// Clone only supports waiting for whole seconds (for now)
	timeout_val.tv_usec = 0;
}

char* wait(unsigned int timeout, int socket_fd) {
	string_length = 0;

	// Malloc 0 to prevent sizeof() from returning 8
	// TODO: Use nicer methods of resetting the result
	result = realloc(result, 0);


	// Set timeout
	timeout_val.tv_sec = timeout;

	if ((s_rc = select(socket_fd + 1, &readfds, NULL, NULL, &timeout_val)) == -1) {
		return NULL;
	} else if (s_rc == 0) {
		// Timeout was reached, return empty string
		return "";
	} else {
		// Accept new connection
		if ((cl = accept(socket_fd, NULL, NULL)) == -1) {
			return NULL;
		}

		// Read from buffer and store string on the heap
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
			// Close connection and return pointer to Clean
			close(cl);
			return result;
		}
	}
}
