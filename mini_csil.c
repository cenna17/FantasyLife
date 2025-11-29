#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

/* ============================ STRUCTS ============================ */
typedef struct Node {
    uint64_t ID;
    uint16_t category;
    struct Node *next;
} Node;

Node* head = NULL;
Node* tail = NULL;
uint64_t globalID = 0;

/* ============================ TIMING ============================ */
double time_diff_sec(struct timespec start, struct timespec end) {
    long sec = end.tv_sec - start.tv_sec;
    long nsec = end.tv_nsec - start.tv_nsec;
    if (nsec < 0) { sec -= 1; nsec += 1000000000L; }
    return sec + nsec / 1e9;
}

/* ============================ NODE CREATION ============================ */
Node* CreateNode(uint16_t category) {
    Node* newNode = malloc(sizeof(Node));
    if (!newNode) { perror("malloc"); exit(1); }
    newNode->ID = globalID++;
    newNode->category = category;
    newNode->next = NULL;
    return newNode;
}

/* ============================ INSERTION FUNCTIONS ============================ */
void Insert_Head(Node* n) {
    n->next = head;
    head = n;
    if (!tail) tail = n;
}

void Insert_Tail_With_PTR(Node* n) {
    if (!head) { head = tail = n; }
    else { tail->next = n; tail = n; }
}

void Insert_Tail_No_PTR(Node* n) {
    if (!head) { head = tail = n; return; }
    Node* curr = head;
    while (curr->next) curr = curr->next;
    curr->next = n;
}

/* ============================ CATEGORY ARRAY ============================ */
uint32_t* CreateCategoryArray(uint16_t n_categories) {
    uint32_t* arr = calloc(n_categories, sizeof(uint32_t));
    if (!arr) { perror("malloc"); exit(1); }
    return arr;
}

/* ============================ FREE LIST ============================ */
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

/* ============================ CATEGORY UPDATE ============================ */
void UpdateCategoryArray(Node* node, uint32_t* category_array, uint16_t n_categories) {
    // Test branch predictability using a simple for-loop scan
    for (uint16_t i = 0; i < n_categories; i++) {
        if (i == node->category) {
            category_array[i]++;
            break;
        }
    }
}

/* ============================ TIMED NODE ADDITION ============================ */
void AddNodesTimed(uint64_t num_nodes, uint16_t n_categories,
                   void (*insert_fn)(Node*), int random_pattern) {

    uint32_t* category_array = CreateCategoryArray(n_categories);
    struct timespec t_start, t_end;
    double total_insert = 0.0, total_update = 0.0;

    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t_start);

    for (uint64_t i = 0; i < num_nodes; i++) {
        uint16_t cat = random_pattern ? rand() % n_categories : (i % n_categories);
        Node* n = CreateNode(cat);

        struct timespec t1, t2;
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
        insert_fn(n);
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
        total_insert += time_diff_sec(t1, t2);

        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
        UpdateCategoryArray(n, category_array, n_categories);
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
        total_update += time_diff_sec(t1, t2);
    }

    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t_end);
    double total_time = time_diff_sec(t_start, t_end);

    printf("Total time: %.6f s | Avg insert: %.9f s | Avg category update: %.9f s\n",
           total_time, total_insert / num_nodes, total_update / num_nodes);

    free(category_array);
    FreeList();
}

/* ============================ MAIN ============================ */
int main() {
    srand(time(NULL));

    uint64_t num_nodes = 100000;
    uint16_t n_categories = 20;

    struct {
        const char* name;
        void (*fn)(Node*);
    } insertions[] = {
        {"Insert_Head", Insert_Head},
        {"Insert_Tail_With_PTR", Insert_Tail_With_PTR},
        {"Insert_Tail_No_PTR", Insert_Tail_No_PTR}
    };

    for (int pattern = 0; pattern <= 1; pattern++) {
        printf("\n=== Pattern: %s ===\n", pattern ? "Random" : "Cycle");
        for (int i = 0; i < 3; i++) {
            printf("\n--- %s ---\n", insertions[i].name);
            AddNodesTimed(num_nodes, n_categories, insertions[i].fn, pattern);
        }
    }

    /* Array implementation */
    printf("\n=== Array Implementation ===\n");
    Node* arr = malloc(num_nodes * sizeof(Node));
    uint32_t* cat_arr = CreateCategoryArray(n_categories);

    for (int pattern = 0; pattern <= 1; pattern++) {
        struct timespec t_start, t_end;
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t_start);

        for (uint64_t i = 0; i < num_nodes; i++) {
            uint16_t cat = pattern ? rand() % n_categories : (i % n_categories);
            arr[i] = cat;
            for (uint16_t j = 0; j < n_categories; j++) {
                if (j == cat) { cat_arr[j]++; break; }
            }
        }

        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t_end);
        double total_time = time_diff_sec(t_start, t_end);
        printf("%s pattern | Total time: %.6f s\n", pattern ? "Random" : "Cycle", total_time);

        for (int j = 0; j < n_categories; j++) cat_arr[j] = 0;
    }

    free(arr);
    free(cat_arr);

    return 0;
}
