class A
  attr_reader :subject, :predicate
  def initialize(subject, predicate)
    @subject = subject
    @predicate = predicate
  end

  def affirmative
    true
  end

  def universal
    true
  end

  def distributed(x)
    @subject == x
  end

  def st
    "All #{@subject} are #{@predicate}"
  end
end

class E
  def initialize(subject, predicate)
    @subject = subject
    @predicate = predicate
  end

  def affirmative
    false
  end

  def universal
    true
  end

  def distributed(x)
    @subject == x or @predicate == x
  end

  def st
    "No #{@subject} are #{@predicate}"
  end
end

class I
  def initialize(subject, predicate)
    @subject = subject
    @predicate = predicate
  end

  def affirmative
    true
  end

  def universal
    false
  end

  def distributed(x)
    false
  end

  def st
    "Some #{@subject} are #{@predicate}"
  end
end

class O
  def initialize(subject, predicate)
    @subject = subject
    @predicate = predicate
  end

  def affirmative
    false
  end

  def universal
    false
  end

  def distributed(x)
    @prediate == x
  end

  def st
    "Some #{@subject} are not #{@predicate}"
  end
end

class Syllogism
  def initialize(majorPremise, minorPremise, conclusion)
    @majorPremise = majorPremise
    @minorPremise = minorPremise
    @conclusion = conclusion
  end

  def analyse
    # A 3-vector of propositions is a well-formed Boolean categorical syllogism iff
    # 1) exactly 3 terms
    # 2) exactly 1 term is shared between the premises
    # 3) the conclusion's predicate is a term in the major premise
    # 4) the conclusion's subject is a term in the minor premise
    notWf = "This is not a well-formed Boolean categorical syllogism"
    if [@majorPremise.subject, @majorPremise.predicate,
     @minorPremise.subject, @minorPremise.predicate,
     @conclusion.subject, @conclusion.predicate].uniq.size != 3
      puts "#{notWf}, the syllogism's propositions must use exactly three terms."
      return false
    elsif @majorPremise.subject != @minorPremise.subject and @majorPremise.subject != @minorPremise.predicate
      # XXX: This isn't quite right, think about this syllogism.
      # All A are B.
      # All A are B.
      # So, All A are A.
      puts "#{notWf}, there must be exactly one term shared between the premises."
      return false
    elsif @conclusion.predicate != @majorPremise.subject && @conclusion.predicate != @majorPremise.predicate
      puts "#{notWf}, the conclusion's predicate must be a term in the major premise."
      return false
    elsif @conclusion.subject != @minorPremise.subject && @conclusion.subject != @minorPremise.predicate
      puts "#{notWf}, the conclusion's subject must be a term in the minor premise."
      return false
    end

    puts "Major Term: #{@conclusion.predicate}"
    puts "Minor Term: #{@conclusion.subject}"
    if @majorPremise.subject == @conclusion.predicate
      middleTerm = @majorPremise.predicate
    else
      middleTerm = @majorPremise.subject
    end
    puts "Middle Term: #{middleTerm}"

    figure = "#{@majorPremise.class.name}#{@minorPremise.class.name}#{@conclusion.class.name}"
    if middleTerm == @majorPremise.subject && middleTerm == @minorPremise.predicate
      puts "Form: #{figure}-1"
    elsif middleTerm == @majorPremise.predicate && middleTerm == @majorPremise.predicate
      puts "Form: #{figure}-2"
    elsif middleTerm == @majorPremise.subject && middleTerm == @majorPremise.subject
      puts "Form: #{figure}-3"
    elsif middleTerm == @majorPremise.predicate && middleTerm == @majorPremise.subject
      puts "Form: #{figure}-4"
    end

    # A well-formed syllogism is a valid argument iff
    # 1) Middle term is distributed in at least one premise
    # 2) If a term is distributed in the conclusion, then it is distributed in a premise.
    # 3) At least one premise is an affirmative proposition.
    # 4) If one of the propositions is negative, then the conclusion is negative.
    # 5) If both premises are universal, then the conclusion is universal.
    notValid = "This is not a valid syllogism"
    if !@majorPremise.distributed(middleTerm) and !@minorPremise.distributed(middleTerm)
      puts "#{notValid}, the middle term must be distributed in at least one premise."
      return false
    elsif @conclusion.distributed(@conclusion.subject) and !@majorPremise.distributed(@conclusion.subject) and !@minorPremise.distributed(@conclusion.subject)
      puts "#{notValid}, the conclusion's subject must be distributed in a premise as its distributed in the conclusion."
      return false
    elsif @conclusion.distributed(@conclusion.predicate) and !@majorPremise.distributed(@conclusion.predicate) and !@minorPremise.distributed(@conclusion.predicate)
      puts "#{notValid}, the conclusion's predicate must be distributed in a premise as its distributed in the conclusion."
      return false
    elsif !@majorPremise.affirmative and !@minorPremise.affirmative
      puts "#{notValid}, at least one premise must be affirmative."
      return false
    elsif (!@majorPremise.affirmative or !@minorPremise.affirmative) and @conclusion.affirmative
      puts "#{notValid}, the conclusion must be negative because one of the premises is."
      return false
    elsif @majorPremise.universal and @minorPremise.universal and !@conclusion.universal
      puts "#{notValid}, the conclusion must be universal because both premises are universal."
      return false
    end

    puts ""
    puts "valid boolean syllogism"
    puts @majorPremise.st
    puts @minorPremise.st
    puts @conclusion.st
  end
end

s = Syllogism.new(
  A.new(:mammals, :animals),
  A.new(:dogs, :mammals),
  A.new(:dogs, :animals)
)
s.analyse
