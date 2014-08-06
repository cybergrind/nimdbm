import sys


def generate(num):
    out = open('test.linedb', 'w')
    for i in xrange(num):
        out.write('{0}:{0}\n'.format(i))
    out.close()

def main():
    generate(int(sys.argv[1]))

if __name__ == '__main__':
    main()
