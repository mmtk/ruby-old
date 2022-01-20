#ifndef MMTK_H
#define MMTK_H

#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void* MMTk_Mutator;
typedef void* MMTk_TraceLocal;

typedef void* MMTk_VMThread;
typedef void* MMTk_VMWorkerThread;
typedef void* MMTk_VMMutatorThread;

typedef struct {
    MMTk_VMWorkerThread (*init_gc_worker_thread)(MMTk_VMThread main_tls);
    void (*stop_the_world)(MMTk_VMWorkerThread tls);
    void (*resume_mutators)(MMTk_VMWorkerThread tls);
    void (*blokc_for_gc)(MMTk_VMMutatorThread tls);
} RubyUpcalls;

/**
 * Initialization
 */
extern void mmtk_init_binding(size_t heap_size, RubyUpcalls *ruby_upcalls);
extern void mmtk_initialize_collection(void *tls);
extern void mmtk_enable_collection();

/**
 * Allocation
 */
extern MMTk_Mutator mmtk_bind_mutator(void *tls);
extern void mmtk_destroy_mutator(MMTk_Mutator mutator);

extern void* mmtk_alloc(MMTk_Mutator mutator, size_t size,
    size_t align, ssize_t offset, int allocator);

extern void* mmtk_alloc_slow(MMTk_Mutator mutator, size_t size,
    size_t align, ssize_t offset, int allocator);

extern void mmtk_post_alloc(MMTk_Mutator mutator, void* refer, void* type_refer,
    int bytes, int allocator);

extern bool mmtk_is_live_object(void* ref);
extern bool mmtk_is_mapped_object(void* ref);
extern bool mmtk_is_mapped_address(void* addr);
extern void mmtk_modify_check(void* ref);

/**
 * Tracing
 */
extern void mmtk_report_delayed_root_edge(MMTk_TraceLocal trace_local,
                                          void* addr);

extern bool mmtk_will_not_move_in_current_collection(MMTk_TraceLocal trace_local,
                                                     void* obj);

extern void mmtk_process_interior_edge(MMTk_TraceLocal trace_local, void* target,
                                      void* slot, bool root);

extern void* mmtk_trace_get_forwarded_referent(MMTk_TraceLocal trace_local, void* obj);

extern void* mmtk_trace_get_forwarded_reference(MMTk_TraceLocal trace_local, void* obj);

extern void* mmtk_trace_retain_referent(MMTk_TraceLocal trace_local, void* obj);

/**
 * Misc
 */
extern bool mmtk_will_never_move(void* object);
extern bool mmtk_process(char* name, char* value);
extern void mmtk_scan_region();
extern void mmtk_handle_user_collection_request(void *tls);

extern void mmtk_start_control_collector(void *tls);
extern void mmtk_start_worker(void *tls, void* worker);

/**
 * VM Accounting
 */
extern size_t mmtk_free_bytes();
extern size_t mmtk_total_bytes();
extern size_t mmtk_used_bytes();
extern void* mmtk_starting_heap_address();
extern void* mmtk_last_heap_address();

/**
 * Reference Processing
 */
extern void mmtk_add_weak_candidate(void* ref, void* referent);
extern void mmtk_add_soft_candidate(void* ref, void* referent);
extern void mmtk_add_phantom_candidate(void* ref, void* referent);

extern void mmtk_harness_begin(void *tls);
extern void mmtk_harness_end();

extern void mmtk_register_finalizable(void *reff);
extern void* mmtk_poll_finalizable(bool include_live);

#ifdef __cplusplus
}
#endif

#endif // MMTK_H
