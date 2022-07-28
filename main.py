from machine import Pin, PWM
import time
from math import log

joints = [PWM(Pin(6)), PWM(Pin(7)), PWM(Pin(8)), PWM(Pin(9))]
joints[0].freq(50)
joints[1].freq(50)
joints[2].freq(50)
joints[3].freq(50)
jointAngles = [10, 10, 180, 0]

# joint 1: 0 jos, 90 sus
# joint 2: 0 jos, 180 sus
# joint 3 0 jos
def angleToPWM(angle):
    maxAngle = 240.00
    maxAngleTime = 2.66 # milis
    return int((((maxAngleTime/maxAngle)*angle)+0.36)/20*65025)
 
def setServo(ID, angle):
    global joints
    joints[ID].duty_u16(angleToPWM(angle))

def setStepperServoPID(ID, angle):
    global joints
    global jointAngles
    currentAngle = jointAngles[ID]
    while currentAngle < angle:
        currentAngle = currentAngle+1
        print(currentAngle)
        joints[ID].duty_u16(angleToPWM(currentAngle))
        time.sleep(0.01*(currentAngle))
        
#try1 : cAng+=1, sleep 001s
#
#
#
def StepperMoveServo(ID, angle):
    global joints
    global jointAngles
    stepsPerTick = 1
    print(jointAngles[ID])
    while abs(jointAngles[ID] - angle) > 0:
        if jointAngles[ID] > angle:
            jointAngles[ID] = jointAngles[ID]-stepsPerTick
        elif jointAngles[ID] < angle:
            jointAngles[ID] = jointAngles[ID]+stepsPerTick
        joints[ID].duty_u16(angleToPWM(jointAngles[ID]))
        #print((0.10 - 0.02*ID))
        time.sleep((0.10 - 0.02*ID))
    
while True:
    print("Usage: joint [Joint ID] angle [Angle]")
    
    command = input()
    command = command.split()
    StepperMoveServo(int(command[1]), int(command[3]))
