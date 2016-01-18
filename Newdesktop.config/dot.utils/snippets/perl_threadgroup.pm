package ThreadsGroup;
use warnings;
use strict;
use threads;
use threads::shared;
use Thread::Semaphore;
use vars qw($VERSION);
$VERSION = 0.4;
sub new
{
        my $invocant = shift;
        my $class = ref($invocant) || $invocant;
        my $default_thread = 10;
        my $self = { 'max_thread' => $default_thread, @_ };
        my $thread_num_sem = Thread::Semaphore->new( $self->{'max_thread'} );
        $self->{'thread_num_sem'} = $thread_num_sem;
        # hashtable use to store working thread
        my %work_threads : shared = ( );
        my $no_more_job : shared = 0;
        $self->{'work_threads'} = \%work_threads;
        $self->{'no_more_job'} = \$no_more_job;
        my $thr = threads->create( "_Monitor", $thread_num_sem, \$no_more_job, \%work_threads );
        # monitor thread
        $self->{'monitor'} = $thr;
        return bless $self, $class;
}
sub _Monitor
{
        my $thread_num_sem = shift;
        my $no_more_job = shift;
        my $work_threads = shift;
        while( 1 )
        {
                # join all threads that can be joined.
                foreach ( keys %{$work_threads} )
                {
                        if( $work_threads->{$_}->{'thread'}->is_joinable() )
                        {
                                $work_threads->{$_}->{'thread'}->join( );
                                #print "thread ".$_." finish.\n";
                                $thread_num_sem->up();
                                delete $work_threads->{$_};
                        }
                }
                if( ${$no_more_job} == 1 )
                {
                        #print "waiting to quit.\n";
                        last;
                }
                sleep 2;
        }
        # last chance to join all threads
        foreach ( threads->list(threads::all) )
        {
                if( threads->self()->equal($_) )
                {
                        #print "get monitor thread, continue\n";
                        next;
                }
                $_->join( );
        }
        return;
}
sub AddJob
{
        my $self = shift;
        my $function = shift;
        my @args = @_;
        $self->{'thread_num_sem'}->down( );
        my $thr = threads->create( $function, @args );
        share( $thr );
        my $ref : shared;
        my %tmp_hash : shared = ( thread=>$thr );
        $ref = \%tmp_hash;
        $self->{'work_threads'}->{$thr->tid()} = $ref;
}
sub WaitAll
{
        my $self = shift;
        ${$self->{'no_more_job'}} = 1;
        $self->{'monitor'}->join();
        undef $self;
}
