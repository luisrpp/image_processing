# frozen_string_literal: true

module ImageProcessing
  # Hough Transform implementation.
  class HoughTransform
    using ImageProcessing::ImageRefinements

    attr_reader :image

    def initialize(image)
      validate_image(image)
      @image = image
    end

    def find_lines
      # TODO
    end

    private

    def validate_image(image)
      raise ImageProcessing::ImageProcessingError, 'Use a greyscale image!' unless image.bands == 1
    end
  end
end
