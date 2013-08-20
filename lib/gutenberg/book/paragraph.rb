class Paragraph
  def initialize string
    @paragraph = string
  end

  def sentences
    segment = -> do
      @sentences = Scalpel.cut @paragraph
    end

    @sentences || segment[]
  end
end
