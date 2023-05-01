=begin
  argument: set of premises and a conclusion
  syllogism: an argument with exactly two premises

  categorical proposition: an A, E, I or I proposition.
  A proposition: a proposition with the form, "All M are N."
  E proposition: a proposition with the form, "No M are N."
  I proposition: a proposition with the form, "Some M are N."
  O proposition: a proposition with the form, "Some M are not N."

  categorical syllogism: a syllogism where each premise and its conclusion are categorical propositions.
  well-formed (WF) categorical syllogism: a categorical syllogism that satisfies each of three requirements,
    a) the conclusion's predicate (major term) is identical to either the first premises' subject or predicate,
    b) the conclusion's subject (minor term) is identical to either the second premises' subject or predicate,
    c) the other terms (middle term) in the first and second premise are identical to eachother, but distinct from the conclusion's subject and predicate.
  XXX: Requiring the middle term to be distinct from the major and minor terms might be superfluous.

  valid WF categorical syllogism: a WF categorical syllogism whose conclusion necessarily follows from its premises.
  invalid WF categorical syllogism: a WF categorical syllogism whose conclusion does not necessarily follow from its premises.

  There are non-categorical syllogisms, such as hypothetical syllogisms,
    If toads live in the desert, then toads don't require much water.
    If toads don't require much water, then toads are mostly immobile.
    Therefore, if toads live in the desert, then toads are mostly immobile.

  Every WF catsyll is exactly one of a VWF catsyll and an IVWF catsyll.
=end

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
    # First, determine if the categorical syllogism is well-formed.
    notWf = "This is not a well-formed categorical syllogism"

    majorPremiseMiddle = nil
    if @conclusion.predicate == @majorPremise.subject
      majorPremiseMiddle = @majorPremise.predicate
    elsif @conclusion.predicate == @majorPremise.predicate
      majorPremiseMiddle = @majorPremise.subject
    else
      puts "#{notWf}, the conclusion's predicate must be a term in the major premise."
      return false
    end

    minorPremiseMiddle = nil
    if @conclusion.subject == @minorPremise.subject
      minorPremiseMiddle = @minorPremise.predicate
    elsif @conclusion.subject == @minorPremise.predicate
      minorPremiseMiddle = @minorPremise.subject
    else
      puts "#{notWf}, the conclusion's subject must be a term in the minor premise."
      return false
    end

    if majorPremiseMiddle != minorPremiseMiddle
      puts "#{notWf}, the major and minor premise must have identical middle terms."
      return false
    elsif majorPremiseMiddle == @conclusion.subject or majorPremiseMiddle == @conclusion.predicate
      puts "#{notWf}, the major premises' middle term must not be identical to either of the conclusion's terms."
      return false
    elsif minorPremiseMiddle == @conclusion.subject or minorPremiseMiddle == @conclusion.predicate
      puts "#{notWf}, the minor premises' middle term must not be identical to either of the conclusion's terms."
      return false
    end
    middleTerm = majorPremiseMiddle

    # Report some details about the well-formed categorical syllogism.
    puts "Major Term: #{@conclusion.predicate}"
    puts "Minor Term: #{@conclusion.subject}"
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

    # Second, decide if a well-formed categorical syllogism is valid.
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
