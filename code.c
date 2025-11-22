/*
clang -O3 -march=native -flto -o code code.c && ./code

*/


#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

/* ============================ GLOBALS && STRUCTS && ENUMS ============================*/
typedef enum {
    CAT_0, CAT_1, CAT_2, CAT_3, CAT_4,
    CAT_5, CAT_6, CAT_7, CAT_8, CAT_9,
    NUM_CATS
} Category;

typedef struct Node {
    uint64_t ID;
    Category myEnum;
    struct Node *next;
} Node;

Node* head = NULL;
Node* tail = NULL;
uint64_t globalID = 0;
/* ============================ TIMING THINGS ============================ */
double time_diff_sec(struct timespec start, struct timespec end) {
    long sec  = end.tv_sec  - start.tv_sec;
    long nsec = end.tv_nsec - start.tv_nsec;

    if (nsec < 0) {
        sec -= 1;
        nsec += 1000000000L;
    }
    return sec + nsec / 1e9;
}

double time_diff_ms(struct timespec start, struct timespec end) {
    long sec  = end.tv_sec  - start.tv_sec;
    long nsec = end.tv_nsec - start.tv_nsec;

    if (nsec < 0) {
        sec  -= 1;
        nsec += 1000000000L;
    }

    return sec * 1000.0 + nsec / 1e6;
}
/* ============================ MAKE NODE ============================ */
Node* CreateNode(Category cat) {
    Node* newNode = (Node*) malloc(sizeof(Node));
    if (!newNode) {
        perror("malloc failed");
        exit(1);
    }
    newNode->ID = globalID++;
    newNode->myEnum = cat;
    newNode->next = NULL;
    return newNode;
}

/* ============================ INSERTION FUNCTIONS ============================ */

void Insert_Head(Node* newNode) {
    newNode->next = head;
    head = newNode;
    if (tail == NULL) tail = newNode;
}

void Insert_Tail_No_PTR(Node* newNode) {
    if (!head) {
        head = tail = newNode;
        return;
    }
    Node* curr = head;
    while (curr->next != NULL) curr = curr->next;
    curr->next = newNode;
}

void Insert_Tail_With_PTR(Node* newNode) {
    if (!head) {
        head = tail = newNode;
    } else {
        tail->next = newNode;
        tail = newNode;
    }
}

/* ============================ MAKE ARRAY OF NUM_CATEGORY ELEMENTS ============================ */

uint32_t* CreateArray(uint16_t num_category) {
    uint32_t* array = (uint32_t*) malloc(num_category * sizeof(uint32_t));
    if (!array) {
        perror("malloc failed");
        exit(1);
    }
    for (uint16_t i = 0; i < num_category; i++)
        array[i] = 0;
    return array;
}

/* ============================ HELPERS ============================ */

void FreeList() {
    Node* curr = head;
    while (curr) {
        Node* tmp = curr;
        curr = curr->next;
        free(tmp);
    }
    head = tail = NULL;
    globalID = 0;
}

/* ============================ ADD TALLY TO ARRAY ============================ */

void UpdateCategoryArray(Node* node, uint32_t* category_array) {
    // Using if statements to simulate branch prediction
    if (node->myEnum == CAT_0) category_array[0]++;
    else if (node->myEnum == CAT_1) category_array[1]++;
    else if (node->myEnum == CAT_2) category_array[2]++;
    else if (node->myEnum == CAT_3) category_array[3]++;
    else if (node->myEnum == CAT_4) category_array[4]++;
    else if (node->myEnum == CAT_5) category_array[5]++;
    else if (node->myEnum == CAT_6) category_array[6]++;
    else if (node->myEnum == CAT_7) category_array[7]++;
    else if (node->myEnum == CAT_8) category_array[8]++;
    else if (node->myEnum == CAT_9) category_array[9]++;
}

/* ============================ FILL LIST ============================ */

/* AddNode_Timed() Description: 
option: category selection pattern (fixed or randomized)
num_nodes: num nodes to be added to linked list
insert option: function pointer to one of INSERTION FUNCTIONS above
category_array: the array which each slot represents a category 
                and the value represents the number of nodes registered to that category

Question: 
    If I make a new array each time I make a new linked list will timing for each list be the 
    same or different for two linked lists using the same category selection pattern options, 
    and insertion functions?

    Case 1: array values of 1st linked list is reset and used by second linked list
    Case 2: we make a second, brand new array for the second linked list to use 
        - I imagine the memory locality for this thing will be horrible as we get more categories and nodes
*/
void AddNode_Timed(uint16_t option, uint64_t num_nodes, void (*insert_option)(Node*), uint32_t* category_array) {
    struct timespec t_start, t_end;
    double total_insert_time = 0.0;
    double total_update_time = 0.0;

    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t_start);

    uint16_t pattern_index = 0;
    for (uint64_t i = 0; i < num_nodes; i++) {
        //Create node
        Category cat = (option == 0) ? (Category)(pattern_index++ % NUM_CATS)
                                     : (Category)(rand() % NUM_CATS);
        Node* newNode = CreateNode(cat);

        //Time category array update
        struct timespec start_update, end_update;
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start_update);
        UpdateCategoryArray(newNode, category_array);
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end_update);
        total_update_time += time_diff_sec(start_update, end_update);

        //Time linked list insertion
        struct timespec start_insert, end_insert;
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start_insert);
        insert_option(newNode);
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end_insert);
        total_insert_time += time_diff_sec(start_insert, end_insert);
    }

    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t_end);

    double total_time = time_diff_sec(t_start, t_end);
    printf("Total time to build list: %.6f s\n", total_time);
    printf("Average insertion time per node (pointer traversal + possible malloc): %.9f s\n", total_insert_time / num_nodes);
    printf("Average category update time per node (branch prediction): %.9f s\n", total_update_time / num_nodes);

    FreeList();
}

int main() {
    srand(time(NULL));
    const uint64_t NUM_NODES_SMALL = 100;      // for timing + branch prediction tests
    const uint64_t NUM_NODES_LARGE = 100000000;    // for locality tests

    // CPU WARMUP 
    for (int i = 0; i < 20000; i++) {
        Node* n = CreateNode(CAT_0);
        Insert_Head(n);
    }
    FreeList();

    // ------------- DEFINE LINKED TEST CASES -------------

    struct {
        const char* name;
        void (*insert_fn)(Node*);
        uint64_t num_nodes;
    } insert_tests[] = {
        {"Insert_Head",             Insert_Head,             NUM_NODES_LARGE},
        //{"Insert_Tail_No_PTR",      Insert_Tail_No_PTR,      NUM_NODES_LARGE},
        {"Insert_Tail_With_PTR",    Insert_Tail_With_PTR,    NUM_NODES_LARGE},
    };

    const char* pattern_name[] = {
        "Set pattern",
        "Random pattern"
    };

    const int NUM_INSERT_FUNCS = sizeof(insert_tests)/sizeof(insert_tests[0]);

    // ------------- RUN ALL COMBINATIONS -------------
    struct timespec t_start, t_end;
    clock_gettime(CLOCK_MONOTONIC, &t_start);

    for (int pattern = 0; pattern < 2; pattern++) {
        printf("\n=============================================\n");
        printf("CATEGORY SELECTION PATTERN: %s\n", pattern_name[pattern]);
        printf("=============================================\n\n");

        for (int t = 0; t < NUM_INSERT_FUNCS; t++) {
            printf("\n--- Test: %s ---\n", insert_tests[t].name);
            printf("Nodes: %lu\n", insert_tests[t].num_nodes);

            // Create fresh array for each test
            uint32_t* category_array = CreateArray(NUM_CATS);

            AddNode_Timed(
                pattern,
                insert_tests[t].num_nodes,
                insert_tests[t].insert_fn,
                category_array
            );

            free(category_array);
            FreeList();
        }
    }

    clock_gettime(CLOCK_MONOTONIC, &t_end);
    double elapsed_ms =
        (t_end.tv_sec - t_start.tv_sec) * 1000.0 +
        (t_end.tv_nsec - t_start.tv_nsec) / 1e6;

    printf("Elapsed: %.3f ms\n", elapsed_ms);

    // ============================ DEFINE ARRAY-BASED TEST ============================
printf("\n=============================================\n");
printf("ARRAY-BASED IMPLEMENTATION\n");
printf("=============================================\n\n");

// Number of nodes (students) same as linked list for comparison
const uint64_t NUM_ARRAY = NUM_NODES_LARGE;  

// Create array to store each student's major
Category *student_array = malloc(NUM_ARRAY * sizeof(Category));
if (!student_array) {
    perror("malloc failed");
    exit(1);
}

// Create category count array
uint32_t *category_array_array = CreateArray(NUM_CATS);

double insert_time = 0.0;
double update_time = 0.0;

// ------------------------- INSERT + CATEGORY UPDATE -------------------------
clock_gettime(CLOCK_MONOTONIC, &t_start);

for (uint64_t i = 0; i < NUM_ARRAY; i++) {
    // Deterministic or random pattern (can test both)
    Category cat = (i % NUM_CATS); // deterministic
    //Category cat = rand() % NUM_CATS; // random

    student_array[i] = cat;

    // Update category array
    category_array_array[cat]++;
}

clock_gettime(CLOCK_MONOTONIC, &t_end);
insert_time = time_diff_ms(t_start, t_end);

printf("Array insertion + category update time (deterministic): %.3f ms\n", insert_time);

// ------------------------- RESET CATEGORY ARRAY -------------------------
for (int i = 0; i < NUM_CATS; i++)
    category_array_array[i] = 0;

// ------------------------- RANDOM PATTERN TEST -------------------------
clock_gettime(CLOCK_MONOTONIC, &t_start);

for (uint64_t i = 0; i < NUM_ARRAY; i++) {
    Category cat = rand() % NUM_CATS;

    student_array[i] = cat;

    category_array_array[cat]++;
}

clock_gettime(CLOCK_MONOTONIC, &t_end);
insert_time = time_diff_ms(t_start, t_end);

printf("Array insertion + category update time (random): %.3f ms\n", insert_time);

// ------------------------- CLEANUP -------------------------
free(student_array);
free(category_array_array);

    return 0;
}
