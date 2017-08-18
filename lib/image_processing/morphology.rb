# frozen_string_literal: true

module ImageProcessing
  # Morphology class
  class Morphology
    class << self
      # Dilation on greyscale images, implemented with maximum filter.
      #
      # @param image [Vips::Image] greyscale image
      # @param size_w [Integer] the width of the window
      # @param size_h [Integer] the height of the window
      #
      # @return [Vips::Image] dilation result
      # @raise [ImageProcessing::ImageProcessingError] in case of invalid images
      def dilate(image, size_w = 3, size_h = size_w)
        validate_image(image)
        image.rank(size_w, size_h, size_w * size_h - 1)
      end

      # Erode on greyscale images, implemented with minimum filter.
      #
      # @param image [Vips::Image] greyscale image
      # @param size_w [Integer] the width of the window
      # @param size_h [Integer] the height of the window
      #
      # @return [Vips::Image] erosion result
      # @raise [ImageProcessing::ImageProcessingError] in case of invalid images
      def erode(image, size_w = 3, size_h = size_w)
        validate_image(image)
        image.rank(size_w, size_h, 0)
      end

      # Opening operator.
      #
      # @param image [Vips::Image] greyscale image
      # @param size_w [Integer] the width of the window
      # @param size_h [Integer] the height of the window
      #
      # @return [Vips::Image] opening result
      # @raise [ImageProcessing::ImageProcessingError] in case of invalid images
      def opening(image, size_w = 3, size_h = size_w)
        dilate(erode(image, size_w, size_h), size_w, size_h)
      end

      # Closing operator.
      #
      # @param image [Vips::Image] greyscale image
      # @param size_w [Integer] the width of the window
      # @param size_h [Integer] the height of the window
      #
      # @return [Vips::Image] closing result
      # @raise [ImageProcessing::ImageProcessingError] in case of invalid images
      def closing(image, size_w = 3, size_h = size_w)
        erode(dilate(image, size_w, size_h), size_w, size_h)
      end

      # Morphological gradient.
      #
      # @param image [Vips::Image] greyscale image
      # @param size_w [Integer] the width of the window
      # @param size_h [Integer] the height of the window
      #
      # @return [Vips::Image] the morphological gradient
      # @raise [ImageProcessing::ImageProcessingError] in case of invalid images
      def gradient(image, size_w = 3, size_h = size_w)
        dilate(image, size_w, size_h)
          .subtract(erode(image, size_w, size_h))
      end

      private

      def validate_image(image)
        raise ImageProcessing::ImageProcessingError, 'Use a greyscale image!' unless image.bands == 1
      end
    end
  end
end
