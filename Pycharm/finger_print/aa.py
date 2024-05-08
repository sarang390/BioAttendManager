import serial
import time

# Open serial port
ser = serial.Serial(port="COM5",baudrate=9600, timeout=1)

# Function to send commands to the fingerprint sensor
def send_command(cmd):
    ser.write(cmd)
    response = ser.read(12)  # Read response (adjust the number of bytes based on your sensor's response)
    return response

# Function to enroll a fingerprint
def enroll_fingerprint():
    # Send enroll command
    ser.write(b'\xEF\x01\xFF\xFF\xFF\xFF\x01\x00\x03\x01\x00\x05')
    response = ser.read(12)  # Read response
    return response

# Function to search for a fingerprint
def search_fingerprint():
    # Send search command
    ser.write(b'\xEF\x01\xFF\xFF\xFF\xFF\x01\x00\x08\x04\x00\x0E\x04\x00\x14')
    response = ser.read(12)  # Read response
    return response

# Main function
def main():
    try:
        # Enroll a fingerprint
        enroll_response = enroll_fingerprint()
        print("Enrollment response:", enroll_response)

        time.sleep(2)  # Wait for sensor to process

        # Search for a fingerprint
        search_response = search_fingerprint()
        print("Search response:", search_response)

    except serial.SerialException as e:
        print("Serial port error:", e)

    finally:
        # Close serial port
        ser.close()

if __name__ == "__main__":
    main()