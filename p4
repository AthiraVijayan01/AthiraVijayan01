#include <stdio.h>

// Structure to represent a process
typedef struct {
    int pid;         // Process ID
    int burstTime;   // Burst Time
    int arrivalTime; // Arrival Time
    int priority;    // Priority
    int waitingTime; // Waiting Time
    int turnaroundTime; // Turnaround Time
} Process;

// Function to sort processes by priority (and arrival time as a tie-breaker)
void sortProcessesByPriority(Process processes[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            if (processes[i].priority > processes[j].priority ||
                (processes[i].priority == processes[j].priority && processes[i].arrivalTime > processes[j].arrivalTime)) {
                Process temp = processes[i];
                processes[i] = processes[j];
                processes[j] = temp;
            }
        }
    }
}

// Function to calculate waiting and turnaround times
void calculateTimes(Process processes[], int n) {
    int completed = 0, currentTime = 0;
    while (completed < n) {
        int highestPriorityIndex = -1;
        for (int i = 0; i < n; i++) {
            if (processes[i].arrivalTime <= currentTime && processes[i].turnaroundTime == 0) {
                if (highestPriorityIndex == -1 || processes[i].priority < processes[highestPriorityIndex].priority) {
                    highestPriorityIndex = i;
                }
            }
        }
        
        if (highestPriorityIndex != -1) {
            processes[highestPriorityIndex].waitingTime = currentTime - processes[highestPriorityIndex].arrivalTime;
            currentTime += processes[highestPriorityIndex].burstTime;
            processes[highestPriorityIndex].turnaroundTime = currentTime - processes[highestPriorityIndex].arrivalTime;
            completed++;
        } else {
            currentTime++;
        }
    }
}

// Function to display the results
void displayResults(Process processes[], int n) {
    float totalWaitingTime = 0, totalTurnaroundTime = 0;
    
    printf("\nProcess\tBurst Time\tArrival Time\tPriority\tWaiting Time\tTurnaround Time\n");
    for (int i = 0; i < n; i++) {
        printf("P%d\t%d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
               processes[i].pid, 
               processes[i].burstTime, 
               processes[i].arrivalTime, 
               processes[i].priority, 
               processes[i].waitingTime, 
               processes[i].turnaroundTime);
        
        totalWaitingTime += processes[i].waitingTime;
        totalTurnaroundTime += processes[i].turnaroundTime;
    }
    
    printf("\nAverage Waiting Time: %.2f\n", totalWaitingTime / n);
    printf("Average Turnaround Time: %.2f\n", totalTurnaroundTime / n);
}

int main() {
    int n;
    
    printf("Enter the number of processes: ");
    scanf("%d", &n);
    
    Process processes[n];
    
    // Input burst times, arrival times, and priorities for each process
    for (int i = 0; i < n; i++) {
        processes[i].pid = i + 1;
        printf("Enter burst time for process P%d: ", processes[i].pid);
        scanf("%d", &processes[i].burstTime);
        printf("Enter arrival time for process P%d: ", processes[i].pid);
        scanf("%d", &processes[i].arrivalTime);
        printf("Enter priority for process P%d (lower number indicates higher priority): ", processes[i].pid);
        scanf("%d", &processes[i].priority);
    }
    
    // Sort processes by priority and then by arrival time
    sortProcessesByPriority(processes, n);
    
    // Calculate waiting and turnaround times
    calculateTimes(processes, n);
    
    // Display the results
    displayResults(processes, n);
    
    return 0;
}
