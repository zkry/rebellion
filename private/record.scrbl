#lang scribble/manual
@(require (for-label racket/base
                     racket/contract/base
                     racket/math
                     rebellion/record)
          scribble/example)

@(define module-sharing-evaluator-factory
   (make-base-eval-factory (list 'racket/base 'rebellion/record)))

@(define (make-evaluator)
   (define evaluator (module-sharing-evaluator-factory))
   (evaluator '(require rebellion/record))
   evaluator)

@title{Records}
@defmodule[rebellion/record]

A @deftech{record} maps each of its keywords to a single value. Records are
similar to hash tables, except keys @emph{must} be keywords. Records are less
dynamic than general-purpose hash tables, but their specialized nature can offer
improved performance. In particular, constructing a record with @racket[record]
and calling a keyword-accepting function with a record impose only constant-time
overhead. Use records instead of hash tables when keys are expected to be
literal names written in source code. As a rule of thumb, if you find yourself
reaching for a hash table whose keys are symbols or strings, use records
instead.

@defproc[(record? [v any/c]) boolean?]{
 A predicate for @tech{records}.}

@defproc[(record [#:<kw> v any/c] ...) record?]{
 Constructs a record containing each @racket[v], where @racket[#:<kw>] stands
 for any keyword.

 @(examples
   #:eval (make-evaluator) #:once
   (record #:name "Alyssa P. Hacker"
           #:age 42
           #:favorite-color 'turqoise))}

@defproc[(record-keywords [rec record?]) (listof keyword?)]{
 Returns the keywords contained in @racket[rec], sorted in ascending order by
 @racket[keyword<?].

 @(examples
   #:eval (make-evaluator) #:once
   (define rec
     (record #:name "Alyssa P. Hacker"
             #:age 42
             #:favorite-color 'turqoise))
   (record-keywords rec))}

@defproc[(record-values [rec record?]) list?]{
 Returns the values contained in @racket[rec], in the same order as the value's
 corresponding keyword in @racket[(record-keywords rec)].

 @(examples
   #:eval (make-evaluator) #:once
   (define rec
     (record #:name "Alyssa P. Hacker"
             #:age 42
             #:favorite-color 'turqoise))
   (record-values rec))}

@defthing[empty-record record?]{
 The empty record, which contains no entries.}

@defproc[(record-size [rec record?]) natural?]{
 Returns the number of keyword-value entries in @racket[rec].

 @(examples
   #:eval (make-evaluator) #:once
   (define rec
     (record #:name "Alyssa P. Hacker"
             #:age 42
             #:favorite-color 'turqoise))
   (record-size rec))}

@defproc[(record-ref [rec record?] [kw keyword?]) any/c]{
 Returns the value in @racket[rec] for @racket[kw], or @racket[#f] if none
 exists.

 @(examples
   #:eval (make-evaluator) #:once
   (define rec
     (record #:name "Alyssa P. Hacker"
             #:age 42
             #:favorite-color 'turqoise))
   (record-ref rec '#:name)
   (record-ref rec '#:fur-color)))}

@defproc[(record-remove [rec record?] [kw keyword?]) record?]{
 Returns @racket[rec] with the entry for @racket[kw] removed.

 @(examples
   #:eval (make-evaluator) #:once
   (record-remove (record #:x 42 #:y 7) '#:x))}

@defproc[(record-merge2
          [rec1 record?]
          [rec2 record?]
          [#:merge merge (-> any/c any/c any/c) (λ (a b) b)])
         record?]{
 Combines @racket[rec1] and @racket[rec2] into a single record containing the
 entries of both. If a keyword is contained in both records the values for that
 key are combined with @racket[merge]. The default merge function ignores the
 first value, causing entries in @racket[rec2] to overwrite entries in @racket[
 rec1].

 @(examples
   #:eval (make-evaluator) #:once
   (record-merge2 (record #:x 1 #:y 2 #:z 3)
                  (record #:name "Alyssa P. Hacker"
                          #:age 42
                          #:favorite-color 'turqoise))
   (record-merge2 (record #:x 1 #:y 2 #:z 3)
                  (record #:z 100))
   (record-merge2 (record #:x 1 #:y 2 #:z 3)
                  (record #:x -1 #:y -2 #:z -3)
                  #:merge +))}
