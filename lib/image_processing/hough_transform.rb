# frozen_string_literal: true

require 'matrix'

module ImageProcessing
  # Hough Transform implementation.
  class HoughTransform
    using ImageProcessing::ImageRefinements

    attr_reader :image

    # Generates the Accumulator Matrix.
    class Accumulator
      attr_reader :theta_res, :rho_res, :matrix

      def initialize(image, theta_res, rho_res)
        @image = image
        @theta_res = theta_res
        @rho_res = rho_res
        @matrix = Matrix.zero(rho_sequence.size, theta_sequence.size).to_a
      end

      def theta_sequence
        return @theta_sequence if @theta_sequence

        theta_start = -Math::PI / 2
        theta_end = (Math::PI / 2) - theta_res
        @theta_sequence = (theta_start..theta_end).step(theta_res).to_a

        @theta_sequence
      end

      def rho_sequence
        return @rho_sequence if @rho_sequence

        diagonal = Math.sqrt((@image.width**2) + (@image.height**2)).ceil
        rho_start = -diagonal
        rho_end = diagonal
        @rho_sequence = (rho_start..rho_end).step(1.0 / rho_res).to_a

        @rho_sequence
      end

      def write(theta, rho)
        rho_index = find_sequence_index(rho_sequence, rho)
        theta_index = find_sequence_index(theta_sequence, theta)

        matrix[rho_index][theta_index] += 1
      end

      # Get all intersections.
      #
      # @param min_value [Integer] minimum number of intersections.
      #
      # @return [Array<Hash<Symbol, Numeric>>] intersections
      def intersections(min_value)
        values = []

        matrix.each_with_index do |row, i|
          row.each_with_index do |value, j|
            values << { rho: rho_sequence[i], theta: theta_sequence[j], value: value } unless value < min_value
          end
        end

        values.sort { |a, b| b[:value] <=> a[:value] }
      end

      # Maximum value in the accumulator matrix.
      #
      # @return [Integer] the maximum value
      def max_value
        max = 0

        matrix.each do |row|
          row_max = row.max
          max = row_max if row_max > max
        end

        max
      end

      def to_image
        matrix_img = Vips::Image.new_from_array matrix
        matrix_img.scaleimage
      end

      private

      def find_sequence_index(sequence, value)
        step_size = sequence[1] - sequence[0]
        (value / step_size.to_f + sequence.size / 2).round
      end
    end

    def initialize(image)
      validate_image(image)
      @image = image
    end

    def find_lines(options = {}) # rubocop:disable Metrics/AbcSize
      default_options = { theta_res: Math::PI / 180, rho_res: 1.0, threshold: 80 }
      options = default_options.merge(options)

      accumulator = Accumulator.new(image, options[:theta_res], options[:rho_res])

      image.non_zero_pixels.each do |pixel|
        accumulator.theta_sequence.each do |theta|
          rho = pixel[:x] * Math.cos(theta) + pixel[:y] * Math.sin(theta)
          accumulator.write(theta, rho)
        end
      end

      # accumulator.to_image.write_to_file('accumulator.jpg')

      accumulator.intersections(accumulator.max_value * options[:threshold] / 100.0)
    end

    private

    def validate_image(image)
      raise ImageProcessing::ImageProcessingError, 'Use a greyscale image!' unless image.bands == 1
    end
  end
end
